# Apollo ZSH Theme

Heavily customizable, compatible, and performant zsh theme.

## Table of Contents

   * [Apollo ZSH Theme](#apollo-zsh-theme)
      * [Table of Contents](#table-of-contents)
      * [Installation](#installation)
         * [Zplugin:](#zplugin)
         * [Prezto:](#prezto)
         * [Oh-My-Zsh:](#oh-my-zsh)
         * [Manual install:](#manual-install)
      * [Features](#features)
      * [Usage](#usage)
      * [Configuration](#configuration)
         * [Core Options](#core-options)
         * [Modules](#modules)
         * [Syntax](#syntax)
         * [Options provided to all modules by framework:](#options-provided-to-all-modules-by-framework)
         * [Module List](#module-list)
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

## Installation


### Zplugin:

```
zplugin ice lucid atinit'fpath+=($PWD/functions.zwc $PWD/functions $PWD/modules.zwc $PWD/modules)'
zplugin light mjrafferty/apollo-zsh-theme
```

### Prezto:

```
```

### Oh-My-Zsh:

```
```

### Manual install:

```
fpath+=( $HOME/apollo-zsh-theme/functions $HOME/apollo-zsh-theme/modules )
autoload -Uz promptinit && promptinit
source apollo-zsh-theme/conf/theme.conf
prompt apollo
```

## Features

## Usage

## Configuration

The prompts are made up of a combination of modules, and each module is made up of one or more elements. There are
elements available to every module, as well as elements specific to certain modules. Both the modules and the elements
that they contain each have access to a variety of attributes to define them. There are a number of attributes available
to every module/element, as well as module specific ones.

All configuration is made done using zstyle's. This offers tremendous context aware flexibility as well as wildcards to
set attributes for a variety of matching modules/elements. Zstyle is provided by the zsh/zutil module and you can read
more about it in the zshmodules man page.

### Core Options

```
zstyle ':apollo:*:core:modules:left' modules 'virtualenv' 'quota' 'public_ip' 'newline' 'root_indicator' 'context' 'dir' 'git' 'vi_mode' 'ruler'
zstyle ':apollo:*:core:modules:right' modules 'command_execution_time' 'background_jobs' 'date' 'clock' 'status' 'newline' 'php_version'

zstyle ':apollo:*:core:*:ruler' style "bold"
zstyle ':apollo:*:core:*:ruler' fg_color "white"
zstyle ':apollo:*:core:*:ruler' text "─"

zstyle ':apollo:*:core:links' enabled "true"

zstyle ':apollo:*:core:cache' disable "true"
zstyle ':apollo:*:core:cache:clear' disable "true"
zstyle ':apollo:*:core:cache:clear' count "3"

zstyle ':apollo:*:core:links:*:*' fg_color "white"
zstyle ':apollo:*:core:links:*:*:*' style "bold"
zstyle ':apollo:*:core:links:*:left:top' text "╭─"
zstyle ':apollo:*:core:links:*:left:mid' text "├─"
zstyle ':apollo:*:core:links:*:left:str' text "│ "
zstyle ':apollo:*:core:links:*:left:bot' text "╰─"
zstyle ':apollo:*:core:links:*:right:top' text "─╮"
zstyle ':apollo:*:core:links:*:right:mid' text "─┤"
zstyle ':apollo:*:core:links:*:right:str' text " │"
zstyle ':apollo:*:core:links:*:right:bot' text "─╯"
zstyle ':apollo:*:core:links:*:*:none' text ""

zstyle ':apollo:*:core:prompt:end' text "> "
zstyle ':apollo:*:core:prompt:end' fg_color "white"

zstyle ':apollo:*:core:profiler' enabled "true"

zstyle ':apollo:*:core:decorations' enabled "true"

zstyle ':apollo:*:*:*:*:*:surround:*' text " "

zstyle ':apollo:*:*:right:*:*:separator' text ""
zstyle ':apollo:*:*:right:*:*:separator' revblend "true"
zstyle ':apollo:*:*:left:*:*:separator' text ""
zstyle ':apollo:*:*:left:*:*:separator' blend "true"

zstyle ':apollo:*:*:*:*:*:begin' blend "true"
zstyle ':apollo:*:*:*:*:*:begin' text ""
zstyle ':apollo:*:*:*:*:*:end' blend "true"
zstyle ':apollo:*:*:*:*:*:end' text ""
```

### Modules

Module Name |Description
---|---
background_jobs|Dispaly number of jobs in background
clock|Displays current time
command_execution_time|Execution time of last command
context|User and hostname
date|Today's date
dir|Current directory
game|Slots game
git|Git repository information
history|History number
php_version|PHP version number from php --version
public_ip|Public IP address
quota|Disk quota warnings
root_indicator|Root status
status|Exit status of last command
vcs|Version control information from vcs_info
vi_mode|Vi mode indicator when using vi key bindings
virtualenv|Active Python virtual environment
newline*|For multiline prompts, signals end of line in module array
ruler**|Same as newline, but finishes line with configurable ruler string. Not useful in right prompt

  \* These are not actual modules and therefore most of the options below do not apply.

### Syntax

```
zstyle ':apollo:<theme>:<line>:<prompt_side>:<module>:<mode>::<element>:<element/module_side>' attribute "value"
                   ^      ^        ^            ^        ^         ^              ^                ^
                   |      |        |            |        |         |              |                Attribute name
                   |      |        |            |        |         |              |
                   |      |        |            |        |         |              left or right side of module/element text if applicable. * for both
                   |      |        |            |        |         |
                   |      |        |            |        |         Subsection of module. Possibly module specific.
                   |      |        |            |        |
                   |      |        |            |        Module mode. Value of * applies to all modes
                   |      |        |            |
                   |      |        |            Module name. Value of * applies to all modules
                   |      |        |
                   |      |        left or right prompt. * for both
                   |      |
                   |      Prompt line number. * for all lines
                   |
                   Active theme or * for all themes
```

### Options provided to all modules by framework:

Module attributes:

Attribute|Description
---|---
width|Minimum width to enforce on module.
always_show|Show module even when it contains empty output.
fg_color|Foreground color for module.
bg_color|Background color for module.
style|Style for module text (bold,standout,underline)

All modules include the following special elements provided by the framework:

Element|Description
---|---
separator|String to use as left module separator when NOT at beginning of line
begin|String to use to left of module when at beginning of line
end|String to use to right of module when at end of line
left:surround|String to left of module text
right:surround|String to right of module text

Two special elements can be set at the module level *AND* as extensions of individual regular elements:

Element|Description
---|---
left:label|String to left of module/element
right:label|String to right of module/element

To better understand how these all fit together, here's a quick reference. The first is a look at the module as a
whole, the second is a closer breakdown of module_text, which is made up of the elements inside the module:

```
{separator/begin}{left:surround}{left:label}{module_text}{right:label}{right:surround}{end}
```

```
{left:label}{element1_text}{right:label}{left:label}{element2_text}{right:label}{etc...}
```

Each of the special elements offer the following attributes:

Attribute|Description
---|---
fg_color|
bg_color|
text|
style|
blend*|
revblend*|

  \*Not valid for surround or label elements.

Modules may also provide additional elements. Any element not listed as "special" above has the following attributes
provided by the framework:

Attribute|Description
---|---
fg_color|
bg_color|
text|
style|

The "text" attribute will not have an effect in many cases if the text is dynamic and generated by the module, but any
elements with static text may utilize the "text" attribute.

All other module options should be controlled via attributes at the module scope, even if they only impact an individual
element in the module. This is done for the sake of providing a uniform configuration interface.

### Module List

#### background_jobs

```
zstyle ':apollo:*:*:*:background_jobs:*' always_show "true"
zstyle ':apollo:*:*:*:background_jobs:*' fg_color "white"
zstyle ':apollo:*:*:*:background_jobs:*' bg_color "cyan"
zstyle ':apollo:*:*:*:background_jobs:*:left:label' text "Jobs: "
```

#### clock

Element|Description
---|---
12hour|
24hour|
min|
sec|
ampm|
timezone|

Attribute|Type|Description|Example
---|---|---|---
live|  |  |
verbose|  |  |

```
zstyle ':apollo:*:*:*:clock:*' elements "12hour" ":" "min" ":" "sec" " " "ampm" " " "timezone"
zstyle ':apollo:*:*:*:clock:*' verbose "true"
zstyle ':apollo:*:*:*:clock:*' live "true"
zstyle ':apollo:*:*:*:clock:*' fg_color "white"
zstyle ':apollo:*:*:*:clock:*' bg_color "darkgreen"
zstyle ':apollo:*:*:*:clock:*' style "bold"
```

#### command_execution_time

Attribute|Type|Description|Example
---|---|---|---
min_duration|  |  |
precision|  |  |

```
zstyle ':apollo:*:*:*:command_execution_time:*' fg_color "white"
zstyle ':apollo:*:*:*:command_execution_time:*' bg_color "navy"
zstyle ':apollo:*:*:*:command_execution_time:*' precision "2"
zstyle ':apollo:*:*:*:command_execution_time:*' min_duration "1"
```

#### context

Mode|Description
---|---
ssh|
sudo|

Element|Description
---|---
user|
host|
sep|

Attribute|Type|Description|Example
---|---|---|---
ignore_hosts|  |  |
ignore_users|  |  |

Ignore multiple hosts or users matching array of basic regex values:

```
zstyle ':apollo:*:*:*:context:*' fg_color "white"
zstyle ':apollo:*:*:*:context:*' bg_color "navy"
zstyle ':apollo:*:*:*:context:default' ignore_users ".*matt.*" ".*raff.*" "root"
zstyle ':apollo:*:*:*:context:ssh' ignore_users ".*matt.*" ".*raff.*" "root"
zstyle ':apollo:*:*:*:context:sudo' ignore_users "root"
zstyle ':apollo:*:*:*:context:*default' ignore_hosts ".*"
zstyle ':apollo:*:*:*:context:sudo' ignore_hosts ".*"
zstyle ':apollo:*:*:*:context:*:sep' text "@"
```

#### date

Element|Description
---|---
dow|
dom|
month|
year|

Attribute|Type|Description|Example
---|---|---|---
verbose|  |  |
elements|  |  |

Extra formatting characters like comma space and slash are allowed as "elements" in the array

```
zstyle ':apollo:*:*:*:date' elements "dow" " " "day" "/" "month" "/" "year"
zstyle ':apollo:*:*:*:date:*:dow' verbose "true"
zstyle ':apollo:*:*:*:date:*' elements "dow" " " "month" " " "day"  ", " "year"
zstyle ':apollo:*:*:*:date:*' fg_color "white"
zstyle ':apollo:*:*:*:date:*' bg_color "blue"
zstyle ':apollo:*:*:*:date:*' verbose "true"
```

#### dir

Mode|Description
---|---
readonly|

Element|Description
---|---
element|
last|
shortened|

Attribute|Type|Description|Example
---|---|---|---
absolute|  |  |
bookmarks|  |  |
bookmark_patterns|  |  |
shorten_length|  |  |
shorten_string|  |  |

```
zstyle ':apollo:*:*:*:dir:*' bg_color "blue"
zstyle ':apollo:*:*:*:dir:*' fg_color "white"
zstyle ':apollo:*:*:*:dir:*' absolute "true"
zstyle ':apollo:*:*:*:dir:*' bookmarks "apollo=$HOME/apollo-zsh-theme"
zstyle ':apollo:*:*:*:dir:*' bookmark_patterns "/home/*/*/html;/html"
zstyle ':apollo:*:*:*:dir:*' last_count "5"
zstyle ':apollo:*:*:*:dir:*' shorten_length "auto"
zstyle ':apollo:*:*:*:dir:*' shorten_string ""
zstyle ':apollo:*:*:*:dir:*:sep' text "/"
zstyle ':apollo:*:*:*:dir:*:sep' style "bold"
zstyle ':apollo:*:*:*:dir:*:sep' fg_color "green"
zstyle ':apollo:*:*:*:dir:*:element' style "bold"
zstyle ':apollo:*:*:*:dir:*:last' style "bold"
zstyle ':apollo:*:*:*:dir:*:last' fg_color "red"
zstyle ':apollo:*:*:*:dir:*:shortened' style "bold"
zstyle ':apollo:*:*:*:dir:*:shortened' fg_color "grey30"
```

#### game

```
zstyle ':apollo:*:*:*:game:*' bg_color "darkblue"
zstyle ':apollo:*:*:*:game:*' fg_color "white"
```

#### git

Element|Description
---|---
local_branch|
remote_branch|
ahead|
behind|
commit_hash|
action|
modified|
untracked|
stash_count|

Attribute|Type|Description|Example
---|---|---|---
elements|  |  |

```
zstyle ':apollo:*:*:*:git:*' elements "local_branch" "action" " " "commit_hash" " " "remote_branch" " " "modified" "|" "untracked" "|" "stash_count"
zstyle ':apollo:*:*:*:git:*' bg_color "black"
zstyle ':apollo:*:*:*:git:*::left:label' text "git "
zstyle ':apollo:*:*:*:git:*::left:label' fg_color "blue"
zstyle ':apollo:*:*:*:git:*' fg_color "yellow"
zstyle ':apollo:*:*:*:git:*:local_branch' fg_color "green"
zstyle ':apollo:*:*:*:git:*:action:left:label' text " "
zstyle ':apollo:*:*:*:git:*:remote_branch' fg_color "red"
zstyle ':apollo:*:*:*:git:*:untracked' fg_color "purple"
```

#### php_version

```
zstyle ':apollo:*:*:*:php_version:*' fg_color "grey93"
zstyle ':apollo:*:*:*:php_version:*' bg_color "fuchsia"
zstyle ':apollo:*:*:*:php_version:*:left:label' text "PHP "
```

#### public_ip

Attribute|Type|Description|Example
---|---|---|---
methods|  |  |
host|  |  |

```
zstyle ':apollo:*:*:*:public_ip:*' fg_color "white"
zstyle ':apollo:*:*:*:public_ip:*' bg_color "darkgreen"
zstyle ':apollo:*:*:*:public_ip:*' methods "curl"
zstyle ':apollo:*:*:*:public_ip:*' host "ipv4.nexcess.net"
```

#### quota

```
zstyle ':apollo:*:*:*:quota:*' fg_color "white"
zstyle ':apollo:*:*:*:quota:*' bg_color "red"
```

#### root_indicator

```
zstyle ':apollo:*:*:*:root_indicator:*' fg_color "yellow"
zstyle ':apollo:*:*:*:root_indicator:*' bg_color "black"
```

#### status

Mode|Description
---|---
bad|

Attribute|Type|Description|Example
---|---|---|---
verbose|  |  |
pipe_status|  |  |
always_show|  |  |

```
zstyle ':apollo:*:*:*:status:*' fg_color "white"
zstyle ':apollo:*:*:*:status:*' bg_color "green"
zstyle ':apollo:*:*:*:status:*' always_show "true"
zstyle ':apollo:*:*:*:status:*' pipe_status "true"
zstyle ':apollo:*:*:*:status:*' verbose "true"
zstyle ':apollo:*:*:*:status:*' bg_color "red"
```

#### vcs

```
zstyle ':apollo:*:*:*:vcs:*' fg_color "white"
zstyle ':apollo:*:*:*:vcs:*' bg_color "green"
```

#### vi_mode

Mode|Description
---|---
insert|
visual|
normal|
replace|

Element|Description
---|---
mode|

```
zstyle ':apollo:*:*:*:vi_mode:*' fg_color "white"
zstyle ':apollo:*:*:*:vi_mode:*' bg_color "grey30"
zstyle ':apollo:*:*:*:vi_mode:insert:mode' text "INSERT"
zstyle ':apollo:*:*:*:vi_mode:visual:mode' text "VISUAL"
zstyle ':apollo:*:*:*:vi_mode:normal:mode' text "NORMAL"
zstyle ':apollo:*:*:*:vi_mode:replace:mode' text "REPLACE"
```

#### virtualenv

```
zstyle ':apollo:*:*:*:virtualenv:*' fg_color "white"
zstyle ':apollo:*:*:*:virtualenv:*' bg_color "blue"
```

---

## Contributing

## FAQ

## Support

## Acknowledgments

## License

[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://badges.mit-license.org)

- **[MIT license](http://opensource.org/licenses/mit-license.php)**
