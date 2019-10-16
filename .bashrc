#!/usr/bin/env bash

if command -v tmux &> /dev/null && [[ -z "${TMUX}" && -z "${SUDO_USER}" ]]; then
    exec tmux
fi

# shellcheck source=/dev/null
. "${HOME}/.bashrc.functions"

# enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    # shellcheck source=/dev/null
    . /usr/share/bash-completion/bash_completion || true
  elif [[ -f /etc/bash_completion ]]; then
    # shellcheck source=/dev/null
    . /etc/bash_completion || true
  fi
else
    return
fi

[[ "${PATH}" == *"${HOME}/.local/bin"* ]] || export PATH=$PATH:$HOME/.local/bin
export HISTTIMEFORMAT="%Y-%m-%d %T "

# Path to the bash it configuration
export BASH_IT="$HOME/.bash_it"

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='boxes-multiline'

# Don't check mail when opening terminal.
unset MAILCHECK

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true
export SCM_GIT_SHOW_DETAILS=true

# Use dir colors
if [[ -e "$HOME/.dir_colors/dircolors.nord" ]]; then
    eval "$(dircolors "$HOME/.dir_colors/dircolors.nord")" || true
fi

# Used to make machine specific changes (not versioned controlled)
# shellcheck source=/dev/null
if [[ -e "$HOME/.bashrc.local" ]]; then
    . "$HOME/.bashrc.local" || true
fi

# shellcheck source=/dev/null
if [[ -e "$HOME/.bash_aliases" ]]; then
    . "$HOME/.bash_aliases" || true
fi

# Load Bash It
# shellcheck source=/dev/null
if [[ -n "$BASH_IT" && -e "$BASH_IT/bash_it.sh" ]]; then
    . "$BASH_IT/bash_it.sh" || true
fi
__append_prompt_command tmux_git_window_name
if [[ $- != *i* || -n "${SSH_CONNECTION}" ]]; then
    return
fi

