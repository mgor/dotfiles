#!/usr/bin/env bash

CURRENT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

# shellcheck disable=SC1090
. "${CURRENT_DIR}/scripts/helpers.sh"

wifi_interpolation=(
    "\#{wifi_symbol}"
    "\#{wifi_frequency}"
    "\#{wifi_quality}"
)
wifi_commands=(
    "#($CURRENT_DIR/scripts/wifi_symbol.sh)"
    "#($CURRENT_DIR/scripts/wifi_frequency.sh)"
    "#($CURRENT_DIR/scripts/wifi_quality.sh)"
)

set_tmux_option() {
    local option="$1"
    local value="$2"
    tmux set-option -gq "$option" "$value"
}

do_interpolation() {
    local all_interpolated="$1"
    for ((i=0; i<${#wifi_commands[@]}; i++)); do
        all_interpolated=${all_interpolated/${wifi_interpolation[$i]}/${wifi_commands[$i]}}
    done
    echo "${all_interpolated}"
}

update_tmux_option() {
    local option="$1"
    local option_value
    local new_option_value
    option_value="$(get_tmux_option "${option}")"
    new_option_value="$(do_interpolation "${option_value}")"

    set_tmux_option "${option}" "${new_option_value}"
}

main() {
    [[ -z "$(get_wifi_interface)" ]] && return 0
    update_tmux_option "status-right"
    update_tmux_option "status-left"
}

main
