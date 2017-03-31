#!/usr/bin/env bash

# Powerline symbols:        

. ~/.config/nord/palette.bash

set_parameters() {
    tmux set -g status-fg "colour${NORD5}"
    tmux set -g status-bg "colour${NORD0}"
    tmux set -g pane-border-fg "colour${NORD3}"
    tmux set -g pane-active-border-fg "colour${NORD11}"
    tmux set -g message-fg "colour${NORD4}"
    tmux set -g message-bg "colour${NORD11}"
    tmux set -g message-command-style "fg=colour${NORD4},bg=colour${NORD5}"
    tmux set -g mode-style "fg=colour${NORD4},bg=colour${NORD15}"
    tmux set -g message-attr bold
    tmux set -g status-left-length 32
    tmux set -g status-right-length 150
    tmux set -g status-interval 5
    tmux set -g default-terminal "screen-256color"
    tmux set -g @prefix_highlight_fg "colour${NORD4}"
    tmux set -g @prefix_highlight_bg "colour${NORD15}"
    tmux set -g @batt_charging_icon "⇈"
    tmux set -g @batt_charged_icon "✓"
    tmux set -g @batt_discharging_icon "⇊"
    tmux set -g @batt_attached_icon "✖"
    tmux set -g @batt_toggle_plug_status "true"
}

set_status_left() {
    tmux set -g status-left "#[fg=colour${NORD4},bg=colour${NORD10},bold] u #[fg=colour${NORD0},bg=colour${NORD8}] #[nobold]$(lsb_release -sr) #[fg=colour${NORD5},bg=colour${NORD0}] "
}

set_status_right() {
    local status_right=""
    [[ -n "$(upower -e | awk '/battery/')" ]] && status_right="#{battery_status_bg} #{battery_percentage} "
    [[ -n "$(nmcli d | awk '/wifi/')" ]] && status_right="${status_right}#[fg=colour${NORD5},bg=colour${NORD2}] #{wifi_frequency} "
    status_right="${status_right}#[fg=colour${NORD3},bg=colour${NORD4}] #(date +"%a") %d %b %R #[fg=colour${NORD4},bg=colour${NORD3}] #h #{prefix_highlight}"
    tmux set -g status-right "${status_right}"
}

set_status_window() {
    tmux set -g window-status-activity-attr bold
    tmux set -g window-status-separator ' '
    tmux set -g window-status-format "#[fg=colour${NORD4},bg=colour${NORD3},noreverse,nobold] #I 〉#W "
    tmux set -g window-status-current-format "#[fg=colour${NORD0},bg=colour${NORD14},noreverse] #I 〉#W "
}

main() {
    set_parameters
    set_status_left
    set_status_right
    set_status_window
}

main
