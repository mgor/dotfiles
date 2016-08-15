#!/usr/bin/env bash

export PATH=$PATH:$HOME/Library/bin:$HOME/.local/bin
export HISTTIMEFORMAT="%Y-%m-%d %T "

# enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
else
    return
fi

if which powerline-daemon > /dev/null && [[ "${USER}" != "root" ]]; then
    bash_bindings="$HOME/.local/lib/python%s/site-packages/powerline/bindings/bash/powerline.sh"
    powerline-daemon -q
    # shellcheck disable=SC2059
    if [[ -e "$(printf "${bash_bindings}" "3.5")" ]]
    then
        # shellcheck disable=SC2059
        . "$(printf "${bash_bindings}" "3.5")"
    else
        # shellcheck disable=SC2059
        . "$(printf "${bash_bindings}" "2.7")"
    fi
fi

# Path to the bash it configuration
export BASH_IT="$HOME/.bash_it"

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='powerline-simple-multiline'

# Don't check mail when opening terminal.
unset MAILCHECK

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true
export SCM_GIT_SHOW_DETAILS=true

[[ "${USER}" != "root" ]] && eval "$(dircolors "$HOME/.dircolors-solarized/dircolors.ansi-dark")"

# Change TERM if we're on an old system
[[ "$(lsb_release -r | awk -F . '{gsub("[^0-9]", "", $(NF-1)); print $(NF-1)}')" -lt 16 ]] && export TERM=xterm-256color

# Used to make machine specific changes (not versioned controlled)
[[ -e "$HOME/.bashrc.local" ]] && . "$HOME/.bashrc.local"

[[ -e "$HOME/.bash_aliases" ]] && . "$HOME/.bash_aliases"

# Load Bash It
[[ -n "$BASH_IT" ]] && source "$BASH_IT/bash_it.sh"

[[ $- != *i* ]] && return
[[ -z "$TMUX" && $(printenv | grep -ci sudo) -eq 0 ]] && exec tmux
