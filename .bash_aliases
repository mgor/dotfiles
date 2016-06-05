_find_code() {
    find . -type f \
        -not -ipath "*tests*" \
        -not -ipath "*build*" \
        -not -ipath "*.git*" \
        -exec grep --color -nH "${1}" {} \;
}

_list_full() {
    [[ -n "${1}" ]] && ls $(pwd)/${1} || ls -d $(pwd)
}

alias ls="ls --color"
alias lsf=_list_full
alias find-code=_find_code
