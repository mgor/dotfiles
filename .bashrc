#!/usr/bin/env bash

# shellcheck source=/dev/null
. "${HOME}/.bashrc.functions"

# enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    # shellcheck source=/dev/null
    . /usr/share/bash-completion/bash_completion
  elif [[ -f /etc/bash_completion ]]; then
    # shellcheck source=/dev/null
    . /etc/bash_completion
  fi
else
    return
fi

start_powerline

export PATH=$PATH:$HOME/.local/bin
export HISTTIMEFORMAT="%Y-%m-%d %T "
export TMUX_THEME="solarized"

# Path to the bash it configuration
export BASH_IT="$HOME/.bash_it"

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='powerline-simple-multiline'

# Don't check mail when opening terminal.
unset MAILCHECK

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true
export SCM_GIT_SHOW_DETAILS=true

# Use dir colors
[[ -e "$HOME/.dir_colors/dircolors" ]] && eval "$(dircolors "$HOME/.dir_colors/dircolors")"

# Used to make machine specific changes (not versioned controlled)
# shellcheck source=/dev/null
[[ -e "$HOME/.bashrc.local" ]] && . "$HOME/.bashrc.local"
# shellcheck source=/dev/null
[[ -e "$HOME/.bash_aliases" ]] && . "$HOME/.bash_aliases"

# Load Bash It
# shellcheck source=/dev/null
[[ -n "$BASH_IT" && -e "$BASH_IT" ]] && . "$BASH_IT/bash_it.sh"
__append_prompt_command tmux_git_window_name
[[ $- != *i* || -n "${SSH_CONNECTION}" ]] && return
which tmux >& /dev/null && [[ -z "$TMUX" && $(printenv | grep -ci sudo) -eq 0 ]] && exec tmux
