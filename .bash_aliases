shopt -s expand_aliases
_find_code() {
    find . -type f \
        -not -ipath "*tests*" \
        -not -ipath "*build*" \
        -not -ipath "*.git*" \
        -exec grep --color -nH "${1}" {} \;
}

_list_full() {
    # shellcheck disable=SC2015
    [[ -n "${1}" ]] && ls "$(pwd)/${1}" || ls -d "$(pwd)"
}

_get_python_lib_dirs() {
    python -c "import os, sys; print(' '.join('{}'.format(d) for d in sys.path if os.path.isdir(d)))"
}

alias ls="ls --color"
alias lsf=_list_full
alias find-code=_find_code
alias _get_python_lib_dirs=_get_python_lib_dirs
