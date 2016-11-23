#!/usr/bin/env bash

[[ "${BASH_SOURCE[0]}" != "${0}" ]] || { echo >&2 "${BASH_SOURCE[0]} must be sourced, and not directly executed"; exit 1; }

tmux_run() {
    local functions="${*}"

    for function in "${functions[@]}"; do
        eval "${function}"
    done
}
