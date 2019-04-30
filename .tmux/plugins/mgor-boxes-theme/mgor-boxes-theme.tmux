#!/usr/bin/env bash

# Powerline symbols:        

. ~/.config/nord/palette.bash

set_parameters() {
    tmux set -g status-fg "colour3"
    tmux set -g status-bg "colour0"
    tmux set -g pane-border-fg "colour8"
    tmux set -g pane-active-border-fg "colour207"
    tmux set -g message-fg "colour0"
    tmux set -g message-bg "colour116"
    tmux set -g message-command-style "fg=colour0,bg=colour116"
    tmux set -g mode-style "fg=colour0,bg=colour116"
    tmux set -g message-attr normal
    tmux set -g status-left-length 32
    tmux set -g status-right-length 150
    tmux set -g status-interval 5
    tmux set -g default-terminal "xterm"
    tmux set -g @prefix_highlight_fg "colour11"
    tmux set -g @prefix_highlight_bg "colour0"
    tmux set -g @batt_charging_icon "⇈"
    tmux set -g @batt_charged_icon "✓"
    tmux set -g @batt_discharging_icon "⇊"
    tmux set -g @batt_attached_icon "✖"
    tmux set -g @batt_toggle_plug_status "true"
    tmux set -g @batt_color_full_charge "#[fg=colour77]"
    tmux set -g @batt_color_high_charge "#[fg=colour184]"
    tmux set -g @batt_color_medium_charge "#[fg=colour208]"
    tmux set -g @batt_color_low_change "#[fg=colour163]"
}

set_status_left() {
    tmux set -g status-left "#[fg=colour250][#[fg=colour208]u#[fg=colour250]]─[#[fg=colour216]$(lsb_release -sr)#[fg=colour250]]─"
}

set_status_right() {
    local status_right="#[fg=colour238]∙#[fg=colour240]∙#[fg=colour250]∙"
    [[ -n "$(upower -e | awk '/battery/')" ]] && status_right="${status_right}#[fg=colour250][#{battery_status_bg}#{battery_percentage}#[fg=colour250,bg=colour0]]─"
    [[ -n "$(nmcli d | awk '/wifi/ && / connected /')" ]] && status_right="${status_right}#[fg=colour250][#[fg=colour217]#{wifi_frequency}#[fg=colour250]]─"
    status_right="${status_right}#[fg=colour250][#[fg=colour116]#(date +"%a") %d %b %R #h#[fg=colour250]]─[#{prefix_highlight}#[fg=colour250]]"
    tmux set -g status-right "${status_right}"
}

set_status_window() {
    tmux set -g status-justify left
    tmux set -g window-status-activity-attr normal
    tmux set -g window-status-separator '#[fg=colour250]─'
    tmux set -g window-status-current-format "#[fg=colour250][#[fg=colour116]#I#[fg=colour207]@#[fg=colour217]#W#[fg=colour250]]"
    tmux set -g window-status-format "#[fg=colour250][#[fg=colour248]#I@#W#[fg=colour250]]"
}

main() {
    set_parameters
    set_status_left
    set_status_right
    set_status_window
}

main
