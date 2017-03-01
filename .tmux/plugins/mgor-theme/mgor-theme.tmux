#!/usr/bin/env bash

# Powerline symbols:        

set_theme() {
    local os="$(lsb_release -si)"
    local title="${os:0:1}"
    local sub_title="$(lsb_release -sr)"

    : ${TMUX_TITLE:=${title}}
    : ${TMUX_SUB_TITLE:=${sub_title}}
    : ${TMUX_COLOR_LIGHTEST:="15"}

    case "${TMUX_THEME}" in
        solarized)
            TMUX_TITLE="u"
            TMUX_COLOR_DARKEST="33"
            TMUX_COLOR_DARK="36"
            TMUX_COLOR_LIGHT="64"
            ;;
        ubuntu)
            TMUX_TITLE="u"
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
    esac

    export TMUX_TITLE TMUX_SUB_TITLE TMUX_COLOR_DARKEST TMUX_COLOR_DARK TMUX_COLOR_LIGHT TMUX_COLOR_LIGHTEST
}

set_theme_parameters() {
    tmux set -g status-fg "colour${TMUX_COLOR_LIGHTEST}"
    tmux set -g status-bg colour234
    tmux set -g pane-border-fg colour245
    tmux set -g pane-active-border-fg "colour${TMUX_COLOR_DARKEST}"
    tmux set -g message-fg "colour${TMUX_COLOR_LIGHTEST}"
    tmux set -g message-bg "colour${TMUX_COLOR_DARKEST}"
    tmux set -g message-command-style "fg=colour${TMUX_COLOR_DARKEST},bg=colour${TMUX_COLOR_LIGHT}"
    tmux set -g mode-style "fg=colour${TMUX_COLOR_LIGHTEST},bg=colour${TMUX_COLOR_DARKEST}"
    tmux set -g message-attr bold
    tmux set -g status-left-length 32
    tmux set -g status-right-length 150
    tmux set -g status-interval 5
    tmux set -g default-terminal "screen-256color"
    tmux set -g @prefix_highlight_fg "colour${TMUX_COLOR_LIGHTEST}"
    tmux set -g @prefix_highlight_bg "colour${TMUX_COLOR_DARKEST}"
    tmux set -g @batt_charging_icon "⇈"
    tmux set -g @batt_charged_icon "✓"
    tmux set -g @batt_discharging_icon "⇊"
    tmux set -g @batt_attached_icon "✖"
    tmux set -g @batt_toggle_plug_status "true"
}

set_status_left() {
    tmux set -g status-left "#[fg=colour${TMUX_COLOR_LIGHTEST},bg=colour${TMUX_COLOR_DARKEST},bold] ${TMUX_TITLE} #[fg=colour${TMUX_COLOR_LIGHTEST},bg=colour${TMUX_COLOR_DARK}] #[nobold]${TMUX_SUB_TITLE} #[fg=colour${TMUX_COLOR_LIGHTEST},bg=colour234] "
}

set_status_right() {
    tmux set -g status-right "#{battery_status_bg} #{battery_percentage} #{battery_icon} #[fg=colour237,bg=colour247] #{wifi_frequency} #[fg=colour234,bg=colour244] #(date +"%a") %d %b %R #[fg=colour247,bg=colour237] #h #{prefix_highlight}"
}

set_status_window() {
    tmux set -g window-status-activity-attr bold
    tmux set -g window-status-separator ' '
    tmux set -g window-status-format "#[fg=colour235,bg=colour239,noreverse,nobold] #I 〉#W "
    tmux set -g window-status-current-format "#[fg=colour${TMUX_COLOR_LIGHTEST},bg=colour${TMUX_COLOR_LIGHT},noreverse] #I 〉#W "
}

main() {
    set_theme
    set_theme_parameters
    set_status_left
    set_status_right
    set_status_window
}

main
