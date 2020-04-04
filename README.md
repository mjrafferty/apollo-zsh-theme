# Apollo ZSH Theme

<p align="center">
  <img src="media/logo.png" alt="Apollo Logo"/>
</p>

Heavily customizable, compatible, and performant zsh theme.

## Table of Contents

   * [Apollo ZSH Theme](#apollo-zsh-theme)
      * [Table of Contents](#table-of-contents)
      * [About](#about)
      * [Features](#features)
      * [Installation](#installation)
         * [Zplugin](#zplugin)
         * [Zgen](#zgen)
         * [Prezto](#prezto)
         * [Oh-My-Zsh](#oh-my-zsh)
         * [Manual install](#manual-install)
      * [Configuration](#configuration)
         * [Core Options](#core-options)
            * [Module Declaration](#module-declaration)
            * [Decorations](#decorations)
            * [Links](#links)
            * [Rulers](#rulers)
            * [Prompt End](#prompt-end)
            * [Caching](#caching)
            * [Profiler](#profiler)
            * [Scrollback Theme](#scrollback-theme)
         * [Modules](#modules)
            * [background_jobs](#background_jobs)
            * [clock](#clock)
            * [command_execution_time](#command_execution_time)
            * [context](#context)
            * [date](#date)
            * [dir](#dir)
            * [game](#game)
            * [git](#git)
            * [php_version](#php_version)
            * [public_ip](#public_ip)
            * [quota](#quota)
            * [root_indicator](#root_indicator)
            * [status](#status)
            * [vcs](#vcs)
            * [vi_mode](#vi_mode)
            * [virtualenv](#virtualenv)
      * [Contributing](#contributing)
      * [FAQ](#faq)
      * [Support](#support)
      * [Acknowledgments](#acknowledgments)
      * [License](#license)

## About

My initial goal was to make a few modifications to another theme to make it compatible with older zsh versions. After reviewing that however, I decided I wasn't at all happy with it and decided to write my own from scratch. This project is the result of that, and has been built with the primary goals of compatibility and flexibility. Due to it's tremendous flexibility, it should be considered more of a theme framework than a theme itself. It should be possible to reproduce just about any existing theme out there, as well as countless other possibilities, using simple configuration changes.

## Features

* Compatible with ZSH 4.3.11 or newer (Possibly older, but this is the oldest version I have to deal with)
* Simple theme creation and customization
* Faster than all but the most basic of prompt themes
* Lots of configuration options
* On the fly theme changing
* Additional modules are easy to create
* Configurable theme for buffered prompt lines. Useful for shortening multiline prompts to single line after command execution.

![Demo](media/demo.gif)

## Installation

### Prezto

```shell
git clone https://github.com/mjrafferty/apollo-zsh-theme $HOME/apollo-zsh-theme

## Add this to bottom of .zprofile
__APOLLO_INSTALL_DIR="$HOME/apollo-zsh-theme"
fpath+=("${__APOLLO_INSTALL_DIR}/functions")

## Set this in .zpreztorc
zstyle ':prezto:module:prompt' theme 'apollo'
```

### Oh-My-Zsh
```shell
git clone https://github.com/mjrafferty/apollo-zsh-theme ${HOME}/apollo-zsh-theme
ln -s ${HOME}/apollo-zsh-theme/apollo-zsh-theme.zsh ${ZSH:-$HOME/.oh-my-zsh}/custom/themes/apollo.zsh-theme

## Set this in .zshrc
ZSH_THEME="apollo"
```

### Zplugin

```shell
zplugin ice lucid atinit'fpath+=($PWD/functions.zwc $PWD/functions ${XDG_DATA_HOME:-${HOME}/.local/share}/apollo $PWD/modules.zwc $PWD/modules)'
zplugin light mjrafferty/apollo-zsh-theme
```

### Zgen

```shell
zgen load mjrafferty/apollo-zsh-theme
```

### Manual install

```shell
git clone https://github.com/mjrafferty/apollo-zsh-theme $HOME/apollo-zsh-theme
source $HOME/apollo-zsh-theme/apollo-zsh-theme.zsh
```


## Configuration

The prompts are made up of a combination of modules, and each module is made up of one or more elements. There are elements available to every module, as well as elements specific to certain modules. Both the modules and the elements that they contain each have access to a variety of attributes to define them. There are a number of attributes available to every module/element, as well as module specific ones.

All configuration is done using zstyle's. This offers tremendous context aware flexibility as well as wildcards to set attributes for a variety of matching modules/elements. Zstyle is provided by the zsh/zutil module and you can read more about it in the zshmodules man page.

Below I'll go over all of the available configuration options. For all of the examples given, I'll be using a theme name of "example".


### Core Options

#### Module declaration

These two options decide what information will be in your prompt and where it will be located. Modules are displayed in the order they are defined. For multiline prompts, add "newline" or "ruler" to list to signal end of line. Prompts can be any number of lines. Note that right prompt does not use "ruler" and the total number of "newline" in right prompt should be less than or equal to the total number of "newline" and "ruler" in left prompt to prevent modules from not being displayed.

Option|Type|Description
---|---|---
zstyle ':apollo:example:core:modules:left' modules|list|Defines what and where items are displayed in left prompt
zstyle ':apollo:example:core:modules:right' modules|list|Defines what and where items are displayed in right prompt


Examples:
```shell
zstyle ':apollo:example:core:modules:left' modules 'virtualenv' 'quota' 'public_ip' 'newline' 'root_indicator' 'context' 'dir' 'git' 'vi_mode' 'ruler'
zstyle ':apollo:example:core:modules:right' modules 'command_execution_time' 'background_jobs' 'date' 'clock' 'status' 'newline' 'php_version'
```


#### Decorations

Line begin/end and separator elements are considered to be decorations. They should typically be enabled, but if they aren't being used and you really need to shave a few milliseconds off of prompt rendering they can be disabled.

Option|Type|Description
---|---|---
zstyle ':apollo:example:core:decorations' enabled|boolean|Enable module begin/end and separator elements

Examples:
```shell
zstyle ':apollo:example:core:decorations' enabled "true"
```


#### Links

Dynamic links added to prompt line ends to join lines together. These get processed on every prompt render, but have little to no effect on performance. However, if they are not used anyway, they can be disabled. The string to use for each link type is configurable, and can also be unique per side and per prompt line.

Option|Type|Description
---|---|---
zstyle ':apollo:example:core:links' enabled|boolean|Enable line links
zstyle ':apollo:example:\<line\>:\<side\>:core:links:\<link_type\>' text|string|String to use for matching links

Link Type|Description
---|---
top|Top link if line has content
mid|Middle link if line has content
str|Middle link if line has NO content
bot|Bottom link
none|Link if line has no content, and lines above have no content

Examples:
```shell
zstyle ':apollo:example:core:links' enabled "true"
zstyle ':apollo:example:*:*:core:links:*' fg_color "white"
zstyle ':apollo:example:*:*:core:links:*' style "bold"
zstyle ':apollo:example:*:left:core:links:top' text "╭─"
zstyle ':apollo:example:*:left:core:links:mid' text "├─"
zstyle ':apollo:example:*:left:core:links:str' text "│ "
zstyle ':apollo:example:*:left:core:links:bot' text "╰─"
zstyle ':apollo:example:*:right:core:links:top' text "─╮"
zstyle ':apollo:example:*:right:core:links:mid' text "─┤"
zstyle ':apollo:example:*:right:core:links:str' text " │"
zstyle ':apollo:example:*:right:core:links:bot' text "─╯"
zstyle ':apollo:example:*:*:core:links:none' text ""
```


#### Rulers

Rulers can be used in multiline prompts to bridge the left and right prompt. The text for these can be made up of strings of any length. Depending on terminal width, the string will be repeated as needed, and will resize with terminal window size changes. Rulers can be configured to be unique on each prompt line.

Option|Type|Description
---|---|---
zstyle ':apollo:example:\<line\>:core:ruler' text|string|Text to use as ruler for matching lines

Examples:
```shell
zstyle ':apollo:example:*:core:ruler' style "bold"
zstyle ':apollo:example:*:core:ruler' fg_color "white"
zstyle ':apollo:example:*:core:ruler' text "─"
```


#### Prompt End

This is the text displayed at the very end of the left prompt after all modules.

Option|Type|Description
---|---|---
zstyle ':apollo:example:core:prompt:end' text|string|Text to display at very end of left prompt

Examples:
```shell
zstyle ':apollo:example:core:prompt:end' text "> "
zstyle ':apollo:example:core:prompt:end' fg_color "white"
```


#### Caching

Many modules are cached based on parameters determined by the module. For the most part this should not require any additional thought for the user, however the user may want to clear cached values on occasion. For instance if a user changes networks, the cache for public_ip may not be accurate. To force a refresh, users can hit enter a configurable number of times in order to clear module cache and force a refresh. This behavior can be disabled, and caching can also be disabled all together if desired.

Option|Type|Description
---|---|---
zstyle ':apollo:example:core:cache' disable|boolean|Disable caching
zstyle ':apollo:example:core:cache:clear' disable|boolean|Disable clearing of cache
zstyle ':apollo:example:core:cache:clear' count|integer|Number of enter presses needed to clear cache

Examples:
```shell
zstyle ':apollo:example:core:cache' disable "true"
zstyle ':apollo:example:core:cache:clear' disable "true"
zstyle ':apollo:example:core:cache:clear' count "3"
```


#### Profiler

This tool is primarily only useful for module development, but if you find your prompt is slow to render it can be used to identify which module is responsible. When enabled, each prompt render will output the module run times to the screen.

Option|Type|Description
---|---|---
zstyle ':apollo:example:core:profiler' enabled|boolean|Enable module profiler

Examples:
```shell
zstyle ':apollo:example:core:profiler' enabled "true"
```


#### Scrollback Theme

Multiline prompts can eat up a lot of space in the scrollback buffer which can be somewhat irritating. To remedy that, a secondary theme can be applied which is set before saving a line to the scrollback buffer. This is most commonly used with a simple single line prompt to prevent wasted space, but any theme can be used here. Note that async modules will not work as the buffer text can not reasonably be modified.

```shell
zstyle ':apollo:example:core:scrollback' theme "scrollback_theme_name"
```

### Modules

Module Name|Description
---|---
[background_jobs](#background_jobs)|Display number of jobs in background
[clock](#clock)|Displays current time
[command_execution_time](#command_execution_time)|Execution time of last command
[context](#context)|User and hostname
[date](#date)|Today's date
[dir](#dir)|Current directory
[game](#game)|Slots game
[git](#git)|Git repository information
[history](#history)|History number
[php_version](#php_version)|PHP version number from php --version
[public_ip](#public_ip)|Public IP address
[quota](#quota)|Disk quota warnings
[root_indicator](#root_indicator)|Root status
[status](#status)|Exit status of last command
[vcs](#vcs)|Version control information from vcs_info
[vi_mode](#vi_mode)|Vi mode indicator when using vi key bindings
[virtualenv](#virtualenv)|Active Python virtual environment
newline*|For multiline prompts, signals end of line in module array
ruler**|Same as newline, but finishes line with configurable ruler string. Not useful in right prompt

  \* These are not actual modules, but have special meaning in the module lists


#### background_jobs

Number of background jobs.

Examples:
```shell
zstyle ':apollo:example:*:*:background_jobs:*' always_show "true"
zstyle ':apollo:example:*:*:background_jobs:*' fg_color "white"
zstyle ':apollo:example:*:*:background_jobs:*' bg_color "cyan"
zstyle ':apollo:example:*:*:background_jobs:*:left:label' text "Jobs: "
```


#### clock

Current time.

Element|Description
---|---
12hour|12 hour clock
24hour|24 hour clock
min|Minute
sec|Second
ampm|AM/PM indicator
timezone|Timezone

Attribute|Type|Description
---|---|---
elements|list|List of elements to display in module. Formatting characters can be added as "elements". See examples.
live|boolean|Refreshes prompt every second. Kind of cool but it causes issues in some environments.
verbose|boolean|Full or condensed output for element

Examples:
```shell
zstyle ':apollo:example:*:*:clock:*' elements "12hour" ":" "min" ":" "sec" " " "ampm" " " "timezone"
zstyle ':apollo:example:*:*:clock:*' verbose "true"
zstyle ':apollo:example:*:*:clock:*' live "true"
zstyle ':apollo:example:*:*:clock:*' fg_color "white"
zstyle ':apollo:example:*:*:clock:*' bg_color "darkgreen"
zstyle ':apollo:example:*:*:clock:*' style "bold"
```


#### command_execution_time

Execution time for last command.

Attribute|Type|Description
---|---|---
min_duration|integer|Don't show execution time if less than this
precision|integer|Number of digits to show after decimal

Examples:
```shell
zstyle ':apollo:example:*:*:command_execution_time:*' fg_color "white"
zstyle ':apollo:example:*:*:command_execution_time:*' bg_color "navy"
zstyle ':apollo:example:*:*:command_execution_time:*' precision "2"
zstyle ':apollo:example:*:*:command_execution_time:*' min_duration "1"
```


#### context

User and hostname info.

Mode|Description
---|---
ssh|If user logged in via SSH
sudo|If user is using sudo

Element|Description
---|---
user|User name
host|Host name
sep|Separator between user and host

Attribute|Type|Description
---|---|---
ignore_hosts|list|List of host names to ignore.
ignore_users|list|List of user names to ignore.

Ignore multiple hosts or users matching array of basic regex values:

Examples:
```shell
zstyle ':apollo:example:*:*:context:*' fg_color "white"
zstyle ':apollo:example:*:*:context:*' bg_color "navy"
zstyle ':apollo:example:*:*:context:default' ignore_users ".*matt.*" ".*raff.*" "root"
zstyle ':apollo:example:*:*:context:ssh' ignore_users ".*matt.*" ".*raff.*" "root"
zstyle ':apollo:example:*:*:context:sudo' ignore_users "root"
zstyle ':apollo:example:*:*:context:*default' ignore_hosts ".*"
zstyle ':apollo:example:*:*:context:sudo' ignore_hosts ".*"
zstyle ':apollo:example:*:*:context:*:sep' text "@"
```


#### date

Today's date.

Element|Description
---|---
dow|Day of week
dom|Day of month
month|Month
year|Year

Attribute|Type|Description
---|---|---
elements|list|List of elements to display in module. Formatting characters can be added as "elements". See examples.
verbose|boolean|Full or condensed output for element

Extra formatting characters like comma space and slash are allowed as "elements" in the array

Examples:
```shell
zstyle ':apollo:example:*:*:date' elements "dow" " " "day" "/" "month" "/" "year"
zstyle ':apollo:example:*:*:date:*:dow' verbose "true"
zstyle ':apollo:example:*:*:date:*' elements "dow" " " "month" " " "day"  ", " "year"
zstyle ':apollo:example:*:*:date:*' fg_color "white"
zstyle ':apollo:example:*:*:date:*' bg_color "blue"
zstyle ':apollo:example:*:*:date:*' verbose "true"
```


#### dir

Current working directory.

Mode|Description
---|---
readonly|Mode if user doesn't have write permissions on directory

Element|Description
---|---
element|Normal part of path
last|Last element in path
shortened|Element that has been shortened

Attribute|Type|Description
---|---|---
absolute|boolean|Use absolute path
bookmarks|list|mapping of named directories of the form "name=PATH"
bookmark_patterns|list|List of patterns to turn into named directories.
shorten_length|integer|Maximum length of directory element name. Auto for dynamic.
shorten_string|string|String to add to shortened elements
last_count||

Examples:
```shell
zstyle ':apollo:example:*:*:dir:*' bg_color "blue"
zstyle ':apollo:example:*:*:dir:*' fg_color "white"
zstyle ':apollo:example:*:*:dir:*' absolute "true"
zstyle ':apollo:example:*:*:dir:*' bookmarks "apollo=$HOME/apollo-zsh-theme"
zstyle ':apollo:example:*:*:dir:*' bookmark_patterns "/home/*/*/html;/html"
zstyle ':apollo:example:*:*:dir:*' last_count "5"
zstyle ':apollo:example:*:*:dir:*' shorten_length "auto"
zstyle ':apollo:example:*:*:dir:*' shorten_string ""
zstyle ':apollo:example:*:*:dir:*:sep' text "/"
zstyle ':apollo:example:*:*:dir:*:sep' style "bold"
zstyle ':apollo:example:*:*:dir:*:sep' fg_color "green"
zstyle ':apollo:example:*:*:dir:*:element' style "bold"
zstyle ':apollo:example:*:*:dir:*:last' style "bold"
zstyle ':apollo:example:*:*:dir:*:last' fg_color "red"
zstyle ':apollo:example:*:*:dir:*:shortened' style "bold"
zstyle ':apollo:example:*:*:dir:*:shortened' fg_color "grey30"
```


#### game

Stupid little slots game.

Examples:
```shell
zstyle ':apollo:example:*:*:game:*' bg_color "darkblue"
zstyle ':apollo:example:*:*:game:*' fg_color "white"
```


#### git

Git repository information.

Element|Description
---|---
local_branch|Local branch name
remote_branch|Remote branch name
ahead|Commits ahead remote
behind|Commits behind remote
commit_hash|Commit hash
action|Current repository action if any
staged|Staged file count
unstaged|Unstaged file count
untracked|Untracked file count
stash_count|Number of stashes
blacklist<sup>1</sup>|Directory is blacklisted

  <sup>1</sup> This is not valid in the element list below. Its purpose is to allow for displaying a string when user is in a blacklisted directory.

Attribute|Type|Description
---|---|---
elements|list|List of elements to display
hash_length|integer|Length of hash to display. Default is 8
ignore_submodules|boolean|Ignore modifications to submodules
blacklist|list|List of directory patterns to ignore
whitelist|list|List of directory patterns to explicitly allow


Examples:
```shell
zstyle ':apollo:example:*:*:git:*' elements "local_branch" "action" " " "commit_hash" " " "remote_branch" " " "staged" "|" "unstaged" "|" "untracked" "|" "stash_count"
zstyle ':apollo:example:*:*:git:*' bg_color "black"
zstyle ':apollo:example:*:*:git:*' blacklist ".*"
zstyle ':apollo:example:*:*:git:*:blacklist' text "This is a git dir"
zstyle ':apollo:example:*:*:git:*::left:label' text "git "
zstyle ':apollo:example:*:*:git:*::left:label' fg_color "blue"
zstyle ':apollo:example:*:*:git:*' fg_color "yellow"
zstyle ':apollo:example:*:*:git:*:local_branch' fg_color "green"
zstyle ':apollo:example:*:*:git:*:action:left:label' text " "
zstyle ':apollo:example:*:*:git:*:remote_branch' fg_color "red"
zstyle ':apollo:example:*:*:git:*:untracked' fg_color "purple"
```


#### php_version

Current PHP version.

Examples:
```shell
zstyle ':apollo:example:*:*:php_version:*' fg_color "grey93"
zstyle ':apollo:example:*:*:php_version:*' bg_color "fuchsia"
zstyle ':apollo:example:*:*:php_version:*:left:label' text "PHP "
```


#### public_ip

Display public IP address.

Element|Description
---|---
curl|Retrieve IP using curl
dig|Retrieve IP using dig
wget|Retrieve IP using wget

Attribute|Type|Description
---|---|---
methods|list|List of methods to retrieve IP info (dig, curl, wget)
host|string|Hostname to poll for ip info

Examples:
```shell
zstyle ':apollo:example:*:*:public_ip:*' fg_color "white"
zstyle ':apollo:example:*:*:public_ip:*' bg_color "darkgreen"
zstyle ':apollo:example:*:*:public_ip:*' methods "curl"
zstyle ':apollo:example:*:*:public_ip:*:curl' host "icanhazip.com"
```


#### quota

Show warning when over disk quota.

Examples:
```shell
zstyle ':apollo:example:*:*:quota:*' fg_color "white"
zstyle ':apollo:example:*:*:quota:*' bg_color "red"
```


#### root_indicator

Display sudo/root status.

Examples:
```shell
zstyle ':apollo:example:*:*:root_indicator:*' fg_color "yellow"
zstyle ':apollo:example:*:*:root_indicator:*' bg_color "black"
```


#### status

Display exit/return status of last command.

Mode|Description
---|---
bad|Mode when return code is abnormal

Attribute|Type|Description
---|---|---
verbose|boolean|Display signal name as well as code
pipe_status|boolean|Display pipe exit codes
always_show|boolean|Show when exit code is 0

Examples:
```shell
zstyle ':apollo:example:*:*:status:*' fg_color "white"
zstyle ':apollo:example:*:*:status:*' bg_color "green"
zstyle ':apollo:example:*:*:status:*' always_show "true"
zstyle ':apollo:example:*:*:status:*' pipe_status "true"
zstyle ':apollo:example:*:*:status:*' verbose "true"
zstyle ':apollo:example:*:*:status:*' bg_color "red"
```


#### vcs

Version control information provided by vcs_info. This covers a wide variety of version control systems. If you only use git, you'll likely prefer the dedicated git module above. Note that this uses the vcs_info function, so you can also configure that directly following the documentation [here](http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Version-Control-Information). The zstyles for it require a user-context, and for that you will need to use 'apollo-vcs' for the settings to impact this module.

Element|Description
---|---
vcs|Name of version control system
branch|Branch name
repo_name|Repository name
action|Current vcs action if any
base_dir|Base directory of repo
sub_dir|Current subdirectory of repo
misc|Varies depending on vcs
revision|Revision/commit hash
staged|Staged changes
unstaged|Unstaged changes
blacklist<sup>1</sup>|Directory is blacklisted

  <sup>1</sup> This is not valid in the element list below. Its purpose is to allow for displaying a string when user is in a blacklisted directory.

Attribute|Type|Description
---|---|---
elements|list|List of elements to display
blacklist|list|List of directory patterns to ignore
whitelist|list|List of directory patterns to explicitly allow


Examples:
```shell
zstyle ':apollo:apollo:*:*:vcs:*' elements "vcs" "branch" "action" "staged" "unstaged" "repo_name" "misc"
zstyle ':apollo:apollo:*:*:vcs:*:(branch|action|staged|unstaged|repo_name|misc):left:label' text ' '
zstyle ':apollo:apollo:*:*:vcs:*:branch' fg_color "green"
zstyle ':apollo:apollo:*:*:vcs:*:staged' text S
zstyle ':apollo:apollo:*:*:vcs:*:unstaged' text U
zstyle ':apollo:apollo:*:*:vcs:*:blacklist' text "vcs"
zstyle ':apollo:apollo:*:*:vcs:*:blacklist' fg_color "green"
```


#### vi_mode

Show current keymapping mode when using Vi key bindings.

Mode|Description
---|---
insert|Insert mode
visual|Visual mode
normal|Normal mode
replace|Replace mode

Element|Description
---|---
mode|Mode text element

Examples:
```shell
zstyle ':apollo:example:*:*:vi_mode:*' fg_color "white"
zstyle ':apollo:example:*:*:vi_mode:*' bg_color "grey30"
zstyle ':apollo:example:*:*:vi_mode:insert:mode' text "INSERT"
zstyle ':apollo:example:*:*:vi_mode:visual:mode' text "VISUAL"
zstyle ':apollo:example:*:*:vi_mode:normal:mode' text "NORMAL"
zstyle ':apollo:example:*:*:vi_mode:replace:mode' text "REPLACE"
```


#### virtualenv

Show Python virtual environment name.

Examples:
```shell
zstyle ':apollo:example:*:*:virtualenv:*' fg_color "white"
zstyle ':apollo:example:*:*:virtualenv:*' bg_color "blue"
```

---

## Contributing

This project was developed by myself and for myself, and because of this it's lacking in themes and modules that others might be interested in. I've written guides on creating these here:

[Module Guide](./docs/module_guide.md)

[Theme Guide](./docs/theme_guide.md)

If you write a module or theme and think others might enjoy it, by all means open a pull request for it.

## FAQ

## Support

Due to other interests and obligations, the amount of time I'm able to devote to this project is limited. Because of this, there is no official support. I am however happy to help within my availability and encourage bug reports and feature requests, as well as identification of areas that are not sufficiently documented.

## License

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

- **[MIT License](http://opensource.org/licenses/mit-license.php)**
