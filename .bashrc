#!/usr/bin/env bash

export PATH=$PATH:$HOME/Library/bin:$HOME/.local/bin

if which powerline-daemon > /dev/null; then
    powerline-daemon -q
    . "$HOME/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh"
fi


# Path to the bash it configuration
export BASH_IT="$HOME/.bash_it"

# Lock and Load a custom theme file
# location /.bash_it/themes/
# Load random color (based on wallpaper)
POWERLINE_THEME_COLORS=(27 35 215 135 205)
export POWERLINE_THEME_COLOR=${POWERLINE_THEME_COLORS[$((RANDOM % ${#POWERLINE_THEME_COLORS[@]}))]}
export BASH_IT_THEME='powerline-simple-multiline'

# Don't check mail when opening terminal.
unset MAILCHECK

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true
export SCM_GIT_SHOW_DETAILS=true

# Used to make machine specific changes (not versioned controlled)
[[ -e "$HOME/.bashrc.local" ]] && . "$HOME/.bashrc.local"

# Load Bash It
source "$BASH_IT/bash_it.sh"
