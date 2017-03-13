#!/usr/bin/env bash

CURRENT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

# shellcheck disable=SC1090
. "${CURRENT_DIR}/helpers.sh"

main() {
    local quality
    quality="$(iwconfig "$(get_wifi_interface)" | awk '/Link Quality/ {gsub(/[^0-9\/]/,"", $2); print $2}')"

    echo "${quality}"
}

main