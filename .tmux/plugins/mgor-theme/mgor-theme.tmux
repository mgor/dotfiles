#!/usr/bin/env bash

# Powerline symbols:        

set_theme() {
    local os="$(lsb_release -si)"
    : ${TMUX_THEME:=${os}}

    TMUX_TITLE="${os:0:1}"
    TMUX_SUB_TITLE="$(lsb_release -sr)"
    TMUX_COLOR_LIGHTEST="15"

    case "${TMUX_THEME,,}" in
        ubuntu)
            TMUX_TITLE="${TMUX_TITLE,,}"
            TMUX_COLOR_DARKEST="166"
            TMUX_COLOR_DARK="172"
            TMUX_COLOR_LIGHT="179"
            ;;
        debian)
            TMUX_TITLE="@"
            TMUX_COLOR_DARKEST="124"
            TMUX_COLOR_DARK="196"
            TMUX_COLOR_LIGHT="203"
            ;;
        fedora)
            TMUX_TITLE="f"
            TMUX_COLOR_DARKEST="21"
            TMUX_COLOR_DARK="27"
            TMUX_COLOR_LIGHT="39"
            ;;
        mac|darwin)
            TMUX_TITLE=""
            TMUX_COLOR_DARKEST="240"
            TMUX_COLOR_DARK="245"
            TMUX_COLOR_LIGHT="248"
            TMUX_COLOR_LIGHTEST="232"
            ;;
        gentoo)
            TMUX_TITLE=">"
            TMUX_COLOR_DARKEST="99"
            TMUX_COLOR_DARK="105"
            TMUX_COLOR_LIGHT="141"
            ;;
        redhat|rhel)
            TMUX_TITLE="RH"
            TMUX_COLOR_DARKEST="124"
            TMUX_COLOR_DARK="196"
            TMUX_COLOR_LIGHT="203"
            ;;
        slackware)
            TMUX_TITLE=".S"
            TMUX_COLOR_DARKEST="234"
            TMUX_COLOR_DARK="240"
            TMUX_COLOR_LIGHT="11"
            ;;
        suse)
            TMUX_TITLE="SuSE"
            TMUX_COLOR_DARKEST="2"
            TMUX_COLOR_DARK="112"
            TMUX_COLOR_LIGHT="155"
            ;;
        arch)
            TMUX_TITLE="A"
            TMUX_COLOR_DARKEST="33"
            TMUX_COLOR_DARK="39"
            TMUX_COLOR_LIGHT="75"
            ;;
        *)
            TMUX_COLOR_DARKEST="166"
            TMUX_COLOR_DARK="172"
            TMUX_COLOR_LIGHT="179"
            ;;
    esac

    export TMUX_TITLE TMUX_SUB_TITLE TMUX_COLOR_DARKEST TMUX_COLOR_DARK TMUX_COLOR_LIGHT TMUX_COLOR_LIGHTEST
}

set_theme_parameters() {
    tmux set -g status-fg "colour${TMUX_COLOR_LIGHEST}"
    tmux set -g status-bg colour234
    tmux set -g window-status-activity-attr bold
    tmux set -g pane-border-fg colour245
    tmux set -g pane-active-border-fg "colour${TMUX_COLOR_DARKEST}"
    tmux set -g message-fg "colour${TMUX_COLOR_LIGHTEST}"
    tmux set -g message-bg "colour${TMUX_COLOR_DARKEST}"
    tmux set -g message-attr bold
    tmux set -g status-left-length 32
    tmux set -g status-right-length 150
    tmux set -g status-interval 5
    tmux set -g default-terminal "screen-256color"
    tmux set -g @prefix_highlight_fg "colour${TMUX_COLOR_LIGHTEST}"
    tmux set -g @prefix_highlight_bg "colour${TMUX_COLOR_DARKEST}"
}

set_status_left() {
    tmux set -g status-left "#[fg=colour${TMUX_COLOR_LIGHTEST},bg=colour${TMUX_COLOR_DARKEST},bold] ${TMUX_TITLE} #[fg=colour${TMUX_COLOR_LIGHTEST},bg=colour${TMUX_COLOR_DARK}] ${TMUX_SUB_TITLE} #[fg=colour${TMUX_COLOR_LIGHTEST},bg=colour234] "
}

set_status_right() {
    tmux set -g status-right '#[fg=colour237,bg=colour247] #(date +"%a") %d %b %R #[fg=colour247,bg=colour237] #h #{prefix_highlight}'
}

set_status_window() {
    tmux set -g window-status-separator ' '
    tmux set -g window-status-format "#[fg=colour235,bg=colour239,noreverse,nobold] #I 〉#W "
    tmux set -g window-status-current-format "#[fg=colour234,bg=colour${TMUX_COLOR_LIGHT},noreverse,bold] #I 〉#W "
}


main() {
    set_theme
    set_theme_parameters
    set_status_left
    set_status_right
    set_status_window
}

main
