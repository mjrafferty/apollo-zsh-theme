# Advanced Usage

* [Fun With Zstyle](#fun-with-zstyle)
* [Overriding Values](#overriding-values)
* [Extending Themes](#extending-themes)
* [Some Assembly Required](#some-assembly-required)

## Fun With Zstyle

The basic format of a zstyle definition is the following:

zstyle 'regex_pattern' attribute value

The patterns are delimited by colons to establish context. The more components in the context string, the more specific it is. Attributes can be defined any number of times with different patterns. If multiple patterns match the lookup string, the one that is the most specific will win. Example:

```shell
zstyle ':apollo:*' fg_color blue
zstyle ':apollo:powerline:*:*:git:*' fg_color red
```

Let's say it's looking up the value for this context string:

```shell
':apollo:powerline:1:left:git:default:main'
```

See [here](./theme_guide.md#syntax) for an explanation of the different parts of the context string. Both of the patterns we defined match this string, however since the second one is more specific, the resulting fg_color will be red. I recommend reading the [zsh/util documentation](http://zsh.sourceforge.net/Doc/Release/Zsh-Modules.html#The-zsh_002fzutil-Module) on zstyle as well for a more detailed explanation.


## Overriding Values

Overriding values or setting new ones can be done anywhere in your shell startup files. It will also source any files ending in .conf in the $XDG_CONFIG_HOME/apollo directory, or in $HOME/.config/apollo if XDG_CONFIG_HOME isn't set. Primary theme files are written to be easily overridden by custom definitions. For the most part, themes should only include styling information, and other settings are defined as defaults that apply to all themes unless overridden elsewhere. So for most settings, you can omit the theme from custom definition patterns, but if you're looking to override theme specific styling, your pattern should include a theme name.

Examples:

```shell
zstyle ':apollo:*:*:*:dir:*' bookmark_patterns '/home/????*/*/html;/html'
zstyle ':apollo:*:*:*:dir:*' bookmarks 'apollo=/home/nexmrafferty/apollo-zsh-theme'
zstyle ':apollo:*:*:*:context:sudo' ignore_hosts '.*'

zstyle ':apollo:apollo:*' fg_color grey
zstyle ':apollo:apollo:*:core:*' fg_color green
zstyle ':apollo:apollo:core:links' enabled false
zstyle ':apollo:apollo:core:prompt:end' fg_color red
zstyle ':apollo:apollo:core:prompt:end' text '>> '
zstyle ':apollo:apollo:*:*:*:*:surround:left' text '(('
zstyle ':apollo:apollo:*:*:*:*:surround:right' text '))'
zstyle ':apollo:apollo:*:*:status:bad:main' style bold
```

These won't conflict with any existing patterns from themes and defaults, so it doesn't matter if the definitions come before or after Apollo gets loaded in your shell startup.

## Extending Themes

Building on what we know from above, It's also possible to extend themes to make custom changes. The patterns in theme files are written with a wildcard after the theme name, so you can use that theme name as a prefix for custom themes to extend it. For example lets make a theme called apollo_custom. You can select this theme just like any other by setting the APOLLO_THEME environment variable:

```shell
APOLLO_THEME=apollo_custom
```

With no other changes aside from setting the environment variable, this will just load the default apollo theme specified by the prefix. However, you can then make your own theme file using apollo as a base:

```shell
zstyle ':apollo:apollo_custom*:*' fg_color grey
zstyle ':apollo:apollo_custom*:*:core:*' fg_color green
zstyle ':apollo:apollo_custom*:core:links' enabled false
zstyle ':apollo:apollo_custom*:core:prompt:end' fg_color red
zstyle ':apollo:apollo_custom*:core:prompt:end' text '>> '
zstyle ':apollo:apollo_custom*:*:*:*:*:surround:left' text '(('
zstyle ':apollo:apollo_custom*:*:*:*:*:surround:right' text '))'
zstyle ':apollo:apollo_custom*:*:*:status:bad:main' style bold
```

Aside from the changes above, the rest of the settings will come from the parent apollo theme. You'll also notice we've added the * to the end of the theme name in the patterns. This will allow you to extend the theme further with apollo_custom_1, apollo_custom_2, etc. 

## Some Assembly Required

The APOLLO_THEME environment variable can be changed at any point during runtime, and the next prompt will show the changes for the new theme. Combining that with the theme extending behavior above, you can do some pretty cool things. Say we've defined the following:

```shell
zstyle ':apollo:*_dev:core*:modules:left' modules 'git' 'context'
zstyle ':apollo:*_prod:core*:modules:left' modules 'public_ip' 'context'
```

You can then manipulate the APOLLO_THEME variable however you want to switch between APOLLO_THEME=apollo_dev and APOLLO_THEME=apollo_prod to control which modules will appear in the prompt. We've also excluded a theme name prefix here, so these module lists will work regardless of which theme you use. Manipulating environment variables is out of scope for this project, but it is a great application for various tools that enable per directory environment variables.
