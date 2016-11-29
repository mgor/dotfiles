#!/usr/bin/env bash

start_powerline() {
    if which powerline-daemon > /dev/null && [[ "${USER}" != "root" ]]; then
        local python_version="$(python3 --version | awk '{print $NF}' | sed -r 's|([0-9]\.[0-9]).*|\1|')"
        powerline-daemon -q
        . "${HOME}/.local/lib/python${python_version}/site-packages/powerline/bindings/bash/powerline.sh"
    fi
}

_set_title() {
    which wmctrl 2>&1 > /dev/null && wmctrl -r :ACTIVE: -N "${*}" 2>&1 > /dev/null
}

__append_prompt_command() {
    if [[ -n $1 ]] ; then
        case $PROMPT_COMMAND in
            *$1*) ;;
            "") PROMPT_COMMAND="$1";;
            *) PROMPT_COMMAND="$PROMPT_COMMAND;$1";;
        esac
    fi
}

_get_git_user() {
    local check="${1:-false}"

    if ${check}; then
        local repository_directory="$(git rev-parse --show-toplevel 2>/dev/null)"
        [[ -z "${repository_directory}" ]] && return 0
    fi

    local url="$(git config --get remote.origin.url)"

    if [[ "${url}" == *"github.com"* ]]; then
        echo "${url}" | sed -r 's|.*:(.*)/.*|\1|g'
    elif [[ "${url}" == *"@"* ]]; then
        echo "${url}" | awk -F@ '{gsub(/^.*?:\/\//, "", $1); print $1}'
    else
        echo "${USER}"
    fi
}

_change_titles() {
    [[ -n "${TMUX}" && -z "${SSH_CLIENT}" ]]
}

tmux_git_window_name() {
    _change_titles || return 0


    local repository_directory="$(git rev-parse --show-toplevel 2>/dev/null)"

    if [[ -z "${repository_directory}" ]]; then
        tmux set-window-option automatic-rename "on" 1>/dev/null
        tmux set set-titles on
    else
        local repository="$(basename "${repository_directory}")"
        local name="$(_get_git_user)"
        [[ -n "${name}" ]] && name+=":"

        tmux set set-titles off
        tmux set-window-option automatic-rename "off" 1>/dev/null
        tmux rename-window " #[nobold]${name}#[bold]${repository}/#[fg=colour237,nobold]${SCM_BRANCH}"
        _set_title "git  ${name}${repository}/${SCM_BRANCH}"
    fi
}

ssh() {
    local parameters=("${@}")

    _change_titles && { tmux set set-titles off; tmux rename-window " ${parameters[-1]}"; _set_title "ssh  ${parameters[-1]}"; }

    command ssh "${@}"

    _change_titles && { tmux set set-titles on; tmux set-window-option automatic-rename "on" 1>/dev/null; }
}

# enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    . /usr/share/bash-completion/bash_completion
  elif [[ -f /etc/bash_completion ]]; then
    . /etc/bash_completion
  fi
else
    return
fi

start_powerline

export PATH=$PATH:$HOME/Library/bin:$HOME/.local/bin
export HISTTIMEFORMAT="%Y-%m-%d %T "

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

# Change TERM if we're on an old system
(( $(lsb_release -sr | awk -F\. '{print $1}') < 16 )) && export TERM=xterm-256color

# Use dir colors
eval $(dircolors "$HOME/.dir_colors/dircolors")

# Used to make machine specific changes (not versioned controlled)
[[ -e "$HOME/.bashrc.local" ]] && . "$HOME/.bashrc.local"
[[ -e "$HOME/.bash_aliases" ]] && . "$HOME/.bash_aliases"

# Load Bash It
[[ -n "$BASH_IT" ]] && source "$BASH_IT/bash_it.sh"
__append_prompt_command tmux_git_window_name
[[ $- != *i* || -n "${SSH_CONNECTION}" ]] && return
[[ -z "$TMUX" && $(printenv | grep -ci sudo) -eq 0 ]] && exec tmux
