#!/usr/bin/env bash

get_version() {
    if [[ -e "/etc/redhat-release" ]]; then
        awk '{print $(NF-1)}' /etc/redhat-release
    else
        lsb_release -sr
    fi
}

get_distribution() {
    if [[ -e "/etc/redhat-release" ]]; then
        if grep -q "Red Hat Enterprise Linux Server" /etc/redhat-release; then
            echo "RHEL"
        elif grep -qi "centos" /etc/redhat-release; then
            echo "CentOS"
        else
            echo "Unknown"
        fi
    else
        case "$(lsb_release -si)" in
            Ubuntu)
                echo "u"
            ;;
            *)
                echo "Unknown"
            ;;
        esac
    fi
}


main() {
    case "$1" in
        version)
            get_version
        ;;
        distribution)
            get_distribution
        ;;
        *)
            echo "unknown parameter: $1"
        ;;
    esac
}

main "$@"
exit $?
