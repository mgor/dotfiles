#!/usr/bin/env bash

main() {
    local extensionUri="${1}"
    local firefoxProfile="${2}"
    local extensionName="${extensionUri%%/*}"
    local unpack=false
    local extensionId suffix

    [[ -z "${firefoxProfile}" ]] && firefoxProfile="$(find "${HOME}/.mozilla" -type d -path "*firefox*" -name "*.default")"
    [[ -z "${firefoxProfile}" ]] && { echo "please start firefox and stop it, so a default profile is created"; exit 1; }

    [[ ! -d /tmp/mgor-firefox-extensions/ ]] && mkdir -p /tmp/mgor-firefox-extensions
    [[ ! -d "${firefoxProfile}/extensions" ]] && mkdir -p "${firefoxProfile}/extensions"

	curl -L -o "/tmp/mgor-firefox-extensions/${extensionName}.xpi" "https://addons.mozilla.org/firefox/downloads/latest/${extensionUri}" || \
        { echo "failed to download ${extensionUri}"; return 1; }

	file "/tmp/mgor-firefox-extensions/${extensionName}.xpi" | grep -q "Zip archive" || \
        { echo "${extensionName}.xpi is not a Zip archive"; return 1; }

	unzip "/tmp/mgor-firefox-extensions/${extensionName}.xpi" \
        -d "/tmp/mgor-firefox-extensions/${extensionName}" &> /dev/null || \
        { echo "failed to extract ${extensionName}.xpi"; return 1; }

    extensionId="$(awk '/urn:mozilla:install-manifest/{c=2}c&&c--' \
        "/tmp/mgor-firefox-extensions/${extensionName}/install.rdf" | \
        awk '/em:id|<id>/{gsub(/<\/?(em:)?id>|.*em:id=/, "", $0); gsub(/"/, "", $0); print $1}' | \
        sed 's/[^[:print:]]//g')"

    grep -q unpack "/tmp/mgor-firefox-extensions/${extensionName}/install.rdf" && unpack=true

    ${unpack} || suffix=".xpi"
    mv "/tmp/mgor-firefox-extensions/${extensionName}${suffix}" \
            "${firefoxProfile}/extensions/${extensionId}${suffix}"

	rm -rf "/tmp/mgor-firefox-extensions/${extensionName}"* || true
}

main "${@}"
exit $?
