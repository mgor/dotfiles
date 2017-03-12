#!/usr/bin/env bash

CURRENT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

# shellcheck disable=SC1090
. "${CURRENT_DIR}/helpers.sh"

main() {
    local frequency
    frequency="$(iwconfig "$(get_wifi_interface)" | awk '/Frequency/ {gsub(/[^0-9\.]/, "", $2); print $2}')"
    [[ -n "${frequency}" ]] && frequency="${frequency:0:3} Ghz" || frequency="n/a"

    echo "${frequency}"
}

main
