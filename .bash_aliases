find_code() {
    find . -type f \
        -not -ipath "*tests*" \
        -not -ipath "*build*" \
        -not -ipath "*.git*" \
        -exec grep --color -nH "${1}" {} \;
}

alias ls="ls --color"
alias find-code=find_code
