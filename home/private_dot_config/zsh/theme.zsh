#!/usr/bin/env zsh

# GitHub Dark theme for zsh-syntax-highlighting
# Based on https://github.com/primer/primitives (GitHub Dark palette)
#
# Color mapping (hex → 256-color):
#   #ff7b72 red/keywords    → 210
#   #a5d6ff strings         → 153
#   #d2a8ff purple/funcs    → 183
#   #ffa657 orange/options  → 215
#   #79c0ff blue/builtins   → 75
#   #7ee787 green/commands  → 114
#   #8b949e gray/comments   → 245

typeset -gA ZSH_HIGHLIGHT_STYLES

# Commands and executables
ZSH_HIGHLIGHT_STYLES[command]='fg=114'             # green - valid commands
ZSH_HIGHLIGHT_STYLES[alias]='fg=114'               # green - aliases
ZSH_HIGHLIGHT_STYLES[builtin]='fg=75'              # blue  - shell builtins
ZSH_HIGHLIGHT_STYLES[function]='fg=183'            # purple - functions
ZSH_HIGHLIGHT_STYLES[precommand]='fg=114,underline' # green underlined - sudo, exec, etc.
ZSH_HIGHLIGHT_STYLES[arg0]='fg=114'                # green - first word (command)

# Keywords and operators
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=210'       # red - if, then, else, fi, etc.
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=210'    # red - ;, &&, ||
ZSH_HIGHLIGHT_STYLES[redirection]='fg=210'         # red - >, >>, <, |
ZSH_HIGHLIGHT_STYLES[globbing]='fg=210'            # red - *, ?, []

# Strings and quoting
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=153'        # light blue
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=153'        # light blue
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=153'        # light blue
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=183'          # purple
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=210' # red

# Variables and assignments
ZSH_HIGHLIGHT_STYLES[assign]='fg=215'              # orange - VAR=value
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=215' # orange - $var inside ""
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=215'   # orange - \n inside ""

# Options and arguments
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=215' # orange - -f
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=215' # orange - --flag

# Paths
ZSH_HIGHLIGHT_STYLES[path]='fg=75,underline'       # blue underlined

# Comments
ZSH_HIGHLIGHT_STYLES[comment]='fg=245'             # gray

# Errors
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=210,bold'  # bold red - invalid commands

# Defaults
ZSH_HIGHLIGHT_STYLES[default]='fg=252'             # light gray - base text
