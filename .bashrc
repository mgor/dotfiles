#!/usr/bin/env bash

start_powerline() {
    if which powerline-daemon > /dev/null && [[ "${USER}" != "root" ]]; then
        local python_version="$(python3 --version | awk '{print $NF}' | sed -r 's|([0-9]\.[0-9]).*|\1|')"
        powerline-daemon -q
        . "${HOME}/.local/lib/python${python_version}/site-packages/powerline/bindings/bash/powerline.sh"
    fi
}

_set_title() {
    echo -e '\033k'${*}'\033\\'
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
        echo "${url}" | sed -r 's|.*[:]?[/]{2}?github.com[:/]?(.*)/.*|\1|g'
    elif [[ "${url}" == *"@"* ]]; then
        echo "${url}" | awk -F@ '{gsub(/^.*?:\/\//, "", $1); print $1}'
    else
        echo "${USER}"
    fi
}

_change_titles() {
    [[ -n "${TMUX}" && -z "${SSH_CLIENT}" ]]
}

_git_configure_repo() {
    local use_defaults="${1}"
    local repo_dir="${2}"

    # if last argument wasn't the directory the repo was cloned to, use the
    # latest created directory/file in the current directory
    ! [[ -d "${repo_dir}" ]] && repo_dir="$(ls -t | head -1)"

    # make sure that the directory actually is a directory, and that a git
    # directory exists
    ! [[ -d "${repo_dir}" && -e "${repo_dir}/.git" ]] && return 0

    export GIT_DIR="${repo_dir}/.git"
    export GIT_WORK_TREE="${repo_dir}"
    local user_name user_email

    if [[ -z "$(git config --get user.name)" ]]; then
        if [[ -z "${GIT_USER_NAME}" ]]; then
            local default_user_name="$(getent passwd "${USER}" | awk -F: '{gsub(",", " ", $5); gsub(/[ \t]+$/, "", $5); print $5}')"
            if ! ${use_defaults}; then
                echo -n "Enter your name [${default_user_name}]: "
                read user_name
            fi
            [[ -z "${user_name}" ]] && user_name="${default_user_name}"
        else
            user_name="${GIT_USER_NAME}"
        fi

        git config user.name "${user_name}"
    fi

    if [[ -z "$(git config --get user.email)" ]]; then
        if [[ -z "${GIT_USER_EMAIL}" ]]; then
            local default_user_email="${USER}@$(hostname -f)"
            if ! ${use_defaults}; then
                echo -n "Enter your e-mail [${default_user_email}]: "
                read user_email
            fi
            [[ -z "${user_email}" ]] && user_email="${default_user_email}"
        else
            user_email="${GIT_USER_EMAIL}"
        fi

        git config user.email "${user_email}"
    fi

    unset GIT_DIR GIT_WORK_TREE
}

tmux_git_window_name() {
    _change_titles || return 0


    local repository_directory="$(git rev-parse --show-toplevel 2>/dev/null)"

    if [[ -z "${repository_directory}" ]]; then
        tmux set-window-option automatic-rename "on" 1>/dev/null
    else
        local repository="$(basename "${repository_directory}")"
        local name="$(_get_git_user)"
        [[ -n "${name}" ]] && name+=":"

        tmux set-window-option automatic-rename "off" 1>/dev/null
        tmux rename-window " #[nobold]${name}#[bold]${repository}/#[fg=colour237,nobold]${SCM_BRANCH}"
        _set_title "git  ${name}${repository}/${SCM_BRANCH}"
    fi
}

ssh() {
    local parameters=("${@}")

    _change_titles && { tmux rename-window " ${parameters[-1]}"; _set_title "ssh  ${parameters[-1]}"; }

    command ssh "${@}"

    _change_titles && { tmux set-window-option automatic-rename "on" 1>/dev/null; }
}

git() {
    local parameters=("${@}")
    local use_defaults=false

    if [[ "${parameters[0]}" == "clone" ]]; then
        [[ "${parameters[1]}" == "--use-defaults" ]] && { unset parameters[1]; use_defaults=true; }
    fi

    command git "${parameters[@]}"

    if [[ "${parameters[0]}" == "clone" ]]; then
        _git_configure_repo ${use_defaults} "${parameters[-1]}"
    fi
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

# Change TERM if we're on an old system
(( $(lsb_release -sr | awk -F\. '{print $1}') < 16 )) && export TERM=xterm-256color

# Use dir colors
[[ -e "$HOME/.dir_colors/dircolors" ]] && eval $(dircolors "$HOME/.dir_colors/dircolors")

# Used to make machine specific changes (not versioned controlled)
[[ -e "$HOME/.bashrc.local" ]] && . "$HOME/.bashrc.local"
[[ -e "$HOME/.bash_aliases" ]] && . "$HOME/.bash_aliases"

# Load Bash It
[[ -n "$BASH_IT" && -e "$BASH_IT" ]] && . "$BASH_IT/bash_it.sh"
__append_prompt_command tmux_git_window_name
[[ $- != *i* || -n "${SSH_CONNECTION}" ]] && return
[[ -z "$TMUX" && $(printenv | grep -ci sudo) -eq 0 ]] && exec tmux
