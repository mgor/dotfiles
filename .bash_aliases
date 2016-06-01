alias ls="ls --color"
find_code() {
    find . -type f -not -ipath "*tests*" -not -ipath "*build*" -exec grep --color -nH "${1}" {} \;
}
alias find-code=find_code

