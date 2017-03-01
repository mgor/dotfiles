get_tmux_option() {
	local option="$1"
	local default_value="$2"
	local option_value
    option_value="$(tmux show-option -gqv "$option")"

    [[ -z "${option_value}" ]] && option_value="${default_value}"

    echo "${option_value}"

}

is_osx() {
	[[ "$(uname)" == "Darwin" ]]
}

is_chrome() {
	chrome="/sys/class/chromeos/cros_ec"
	if [ -d "$chrome" ]; then
		return 0
	else
		return 1
	fi
}

command_exists() {
	local command="$1"
	type "$command" >/dev/null 2>&1
}

get_wifi_interface() {
	nmcli d | awk '/wifi/ {print $1}'
}
