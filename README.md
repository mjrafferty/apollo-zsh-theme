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
         * [Modules](#modules)
         * [Syntax:](#syntax)
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

### Modules

Module Name |Description
---|---
background_jobs|
clock|
command_execution_time|
context|
date|
dir|
game|
git|
history|
php_version|
public_ip|
quota|
root_indicator|
status|
vcs|
vi_mode|
virtualenv|
newline*|
ruler*|


### Syntax:

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

  Attributes|Description
  ---|---
  width|
  always_show|
  fg_color|
  bg_color|
  style|

All modules include the following special elements provided by the framework:

  Element|Description
  ---|---
  separator|
  begin|
  end|
  left:surround|
  right:surround|

Two special elements can be set at the module level AND as extensions of individual regular elements:

  Element|Description
  ---|---
  left:label|
  right:label|

Each of the special elements the following attributes:

  Special Element Attributes:

  Attributes|Description
  ---|---
  fg_color|
  bg_color|
  text|
  style|
  blend*|
  revblend*|

  \*Not valid for surround or label elements.

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
