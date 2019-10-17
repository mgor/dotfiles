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

_json_pp() {
    local input="${*}"

    if [[ "${input}" == "-" || -z "${input}" ]]; then
        python -m json.tool
    else
        echo "${input}" | python -m json.tool
    fi
}

_xml_pp() {
    local input="${1}"

    if [[ "${input}" == "-" || -z "${input}" ]]; then
        awk '{printf $0}' | sed -r 's|||g' | xmllint --format -
    else
        awk '{print $0}' "${input}" | sed -r 's|||g' | xmllint --format -
    fi

}

_sort_p() {
    local file="${1}"
    perl -n00 -e 'push @a, $_; END { print sort @a }' "${file}"
}

alias ls="ls --color"
alias lsf=_list_full
alias fuck='sudo $(history -p !!)'
alias find-code=_find_code
alias json-pp=_json_pp
alias xml-pp=_xml_pp
alias sort-p=_sort_p
alias tail=colortail
alias _get_python_lib_dirs=_get_python_lib_dirs
alias pylint="/usr/bin/env python $(which pylint)"
alias pep8="/usr/bin/env python $(which pep8)"
alias mypy="/usr/bin/env python $(which mypy)"
