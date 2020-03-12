## Making Modules

   * [Making Modules](#making-modules)
      * [Introduction](#introduction)
      * [Profiling](#profiling)
      * [Basic Module](#basic-module)
      * [Avoiding Forks](#avoiding-forks)
      * [Using Cache](#using-cache)
      * [Adding Options](#adding-options)
      * [Asynchronous Execution](#asynchronous-execution)
      * [Module Elements](#module-elements)
      * [Sanitizing Values](#sanitizing-values)
      * [Buffered Output](#buffered-output)
      * [Things to Avoid](#things-to-avoid)

### Introduction

At this point in time the included modules are very much tailored for my own usage. I'm sure there's a great deal of desirable modules that aren't yet present. They're generally easy to make, so I've written this guide on the process.

Modules are comprised of a single file named '\_\_apollo\_{module_name}\_load'. Custom modules can be placed in '${XDG_DATA_HOME}/apollo/' or /home/user/.local/share/apollo/ if XDG_DATA_HOME is not set.

### Profiling

When developing modules, it's important to keep track of their performance impact. To do so, I've included a basic profiling tool that can be enabled with this config setting:

```shell
zstyle ':apollo:apollo:core:profiler' enabled "true"
```

Replace the second 'apollo' with whatever theme you're using, or an * to match all themes. The output of this will be in the form:

module_name: duration cache_status

### Basic Module

Every module should define at-least one function by the name of '\_\_apollo\_{module_name}\_run'. The value this function returns is passed back by setting the '\_\_apollo_RETURN_MESSAGE' variable.

For the duration of this guide, we're going to focus on developing a module that does one simple task, listing the number of files in your current directory. The actual methods I'm using to get that data are extremely flawed, but it gives us an easy data point to demonstrate module creation. Here is a very basic implementation of that:

```shell
__apollo_file_count_run() {
  __APOLLO_RETURN_MESSAGE="$(ls $PWD | wc -l)"
}
```
That's it. That's a module. Though it is a very poor one. Using the profiler mentioned above we see something like this:

file_count: 0.014517 MISS

That's not an exceptionally long time, but it adds a lot more latency than necessary to every prompt. That brings us to our next section.


### Avoiding Forks

The biggest issue with our module is it generates quite a few extra processes to do the work. It's a lot lighter to do everything you can in the shell that's already running. We should avoid using external programs as well as implicit and explicit sub-shells whenever possible. An explicit sub-shell would be a command wrapped in '$()', where as implicit sub-shells are created by things like pipes. To avoid all of that, we can do the same job with the following:

```shell
__apollo_file_count_run() {

  local file
  local count=0

  for file in * ; do
    ((count++));
  done

  __APOLLO_RETURN_MESSAGE="$count"

}
```

This gives us much better performance:

file_count: 0.000670 MISS


### Using Cache

It's extremely unnecessary to count the number of items in a directory on every prompt, so let's make use of cache. Using cache is very easy, though it might not always be so easy to pick a good cache key. To add caching to a module, all that is needed is to define a function named '\_\_apollo\_{module_name}\_cache_key' and return a value to use as the key via the '\_\_apollo_RETURN_MESSAGE' variable. For this module. The '$PWD' variable will work well as a cache key:

```shell
__apollo_file_count_cache_key() {
  __APOLLO_RETURN_MESSAGE="$PWD"
}

__apollo_file_count_run() {

  local file
  local count=0

  for file in * ; do
    ((count++));
  done

  __APOLLO_RETURN_MESSAGE="$count"

}
```

So now with our profiler we'll see something like this once the value for that directory is in cache:

file_count: 0.000109 HIT


### Adding Options

Now that we have a basic module, let's add some customizable options to it. All custom options are controlled via zstyles. Zstyles allow for unique option values based on the current context. For more detail on the context for these styles, click [here](./README.md#syntax). When modules are called, the framework passes the current context as the first parameter. This context includes everything up to the module mode, which is set to the value "default" prior to running the module. 

If your module implements additional modes, its best to identify the current mode and set it as early as possible so that the code afterwards can apply mode specific options. For telling the framework of a mode change, we use the '\_\_apollo_set_mode' function, with the first argument being the module name, and the second being the new mode.

For our file count module, we're going to set a mode called "big" to indicate there are a lot of files in the current directory. We'll allow the user to decide how many files is considered a lot. We'll also add a verbose option so that the user can choose between showing the exact count or to instead show a string of their choosing based on the mode:

```shell
__apollo_file_count_cache_key() {
  __APOLLO_RETURN_MESSAGE="$PWD"
}

__apollo_file_count_run() {

  local context="$1"
  local file
  local count=0
  local big_count mode is_verbose text;

  for file in * ; do
    ((count++));
  done

  zstyle -s "${context}:${mode}" big_count big_count

  if ((count >= big_count)); then
    __apollo_set_mode "file_count" "big"
    mode="big"
  fi

  zstyle -b "${context}:${mode}" verbose is_verbose

  if [[ "$is_verbose" == "yes" ]]; then
    __APOLLO_RETURN_MESSAGE="$count"
  fi

}
```

We'll also add the following to our configuration file:

```shell
zstyle ':apollo:apollo:*:*:file_count:default' big_count 10
zstyle ':apollo:apollo:*:*:file_count:*' verbose false
zstyle ':apollo:apollo:*:*:file_count:default' text 'Meh'
zstyle ':apollo:apollo:*:*:file_count:big' text 'Wow'
zstyle ':apollo:apollo:*:*:file_count:big:main' fg_color yellow
zstyle ':apollo:apollo:*:*:file_count:big:main' style bold
```

So we've decided that if a directory has more than 10 items in it, that's a lot. And since verbose is set to false, we just show the strings from the config file. If a directory has less than 10 objects, it shows "Meh". If there are 10 objects or more, we set the module text to "Wow" and display it in bold red text.

### Asynchronous Execution

To run this module asynchronously, all we need to do is change the function name from '\_\_apollo\_{module_name}\_run' to '\_\_apollo\_{module_name}\_async'. This will run the async function only when no cache value is present. There also exists an '\_\_apollo\_{module_name}\_always_async' function which will run on every prompt. Cache is still used in this case to prevent the harsh pop in caused by asynchronous operation, but the displayed value will update if needed once the async operation has completed. For this module, we don't need it to run on every prompt so we're just going to use the standard async function. Since this is no longer blocking the main prompt render, we can even sprinkle in some external commands and sub-shells if we want without caring too much:

```shell
__apollo_file_count_cache_key() {
  __APOLLO_RETURN_MESSAGE="$PWD"
}

__apollo_file_count_async() {

  local context="$1"
  local mode="default"
  local count=0
  local big_count is_verbose text;

  count=$(ls | wc -l)

  zstyle -s "${context}:${mode}" big_count big_count

  if ((count >= big_count)); then
    __apollo_set_mode "file_count" "big"
    mode="big"
  fi

  zstyle -b "${context}:${mode}" verbose is_verbose

  if [[ "$is_verbose" == "yes" ]]; then
     __APOLLO_RETURN_MESSAGE="$count"
  fi

}
```

If no other function named '\_\_apollo\_{module_name}\_run' exists, the framework will use the return value from the async function as the display text, as well as the mode that's set during the async function if any. In rare cases you may decide you want to use both an async function and still use an '\_\_apollo\_{module_name}\_run' function as well. When this is done, the framework will pass the value from the async function as the second parameter to the run function, and the mode is left at whatever the async function set it as if not default.

### Module Elements

For more complex modules, you may have several components that make up the module text. These can all be styled and have their own left and right labels separate from the module text itself. To do this we can use the '\_\_apollo_set_style' function, which will set the colors, styles, and labels for the string. Note that these values are cached using the context as the cache key. This is not always desirable for values that are more dynamic, so there are two ways to use it.

The simple way will style and cache the element text and can be done with the following code:

```shell
__apollo_set_style "${context}:${mode}:${element}" "$string"
element="${__APOLLO_RETURN_MESSAGE}"
```

If the value for the given element context is dynamic, you can use the --dynamic flag. This caches only the styles and labels, but excludes the element text itself. Because of that, we need to split the response into two parts by splitting on the NULL character '\0'. We then wrap those two parts around our uncached element text:

```shell
__apollo_set_style "${context}:${mode}:${element}" --dynamic
style=("${(s.\0.)__APOLLO_RETURN_MESSAGE}")
element="${style[1]}${element}${style[2]}"
```

### Sanitizing values

Whenever you're working with unpredictable values, it's a good idea to sanitize them before displaying them in the prompt. There are pretty much only three characters that can be problematic here, \`, $, and %. For this you can use the '\_\_apollo_sanitize' function to escape the needed characters:

```shell
__apollo_sanitize "$string"
string="$__APOLLO_RETURN_MESSAGE"
```

### Buffered output

For the most part, you should avoid using sub-shells, and pipes inside of an '\_\_apollo\_{module_name}\_run' function. To help with that, the framework catches stdout in a buffer that you can operate on within the module. Say for example you need to get the zsh version and you aren't aware of the better ways to do this:

```shell
zsh --version
sysread -i ${__APOLLO_BUFFER_FD} output_string
```

The output of the command is sent to the buffer, and then you read in from the buffer file descriptor to assign it to the variable called "$output_string". Note that reading the data this way does so line by line, so you'd need to do it multiple times for multi line output. It's also important to note that this buffer is ___NOT___ available with async functions, so this should be thought of if converting a function to async.


### Things to Avoid

The most difficult goal of this project is to maintain compatibility with older zsh versions. I've decided that it would be beneficial to maintain a list of items that are not compatible with older versions. 

  1. =~ operator (risk of segfault)
  2. add-zle-hook-widget (not present)
  3. sysopen (not present)
  4. zmathfunc (not present)

