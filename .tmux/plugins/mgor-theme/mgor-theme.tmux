#!/usr/bin/env bash

. ~/.tmux/tmux.inc.sh

set_theme_parameters() {
    tmux set -g status-fg white
    tmux set -g status-bg colour234
    tmux set -g window-status-activity-attr bold
    tmux set -g pane-border-fg colour245
    tmux set -g pane-active-border-fg colour166
    tmux set -g message-fg colour15
    tmux set -g message-bg colour166
    tmux set -g message-attr bold
    tmux set -g status-left-length 32
    tmux set -g status-right-length 150
    tmux set -g status-interval 5
    tmux set -g default-terminal "screen-256color"
    tmux set -g @prefix_highlight_fg 'colour15'
    tmux set -g @prefix_highlight_bg 'colour166'
}

set_status_left() {
    # Powerline symbols:        
    local os="$(lsb_release -si)"
    local version="$(lsb_release -sr)"
    local text
    if [[ "${os}" == "Ubuntu" ]]; then
        text="u"
    else
        text="${os:0:1}"; text="${text,,}"
    fi
    tmux set -g status-left "#[fg=colour15,bg=colour166,bold] ${text} #[fg=colour15,bg=colour172] ${version} #[fg=white,bg=colour234] "
}

set_status_right() {
    tmux set -g status-right '#[fg=colour237,bg=colour247] #(date +"%a") %d %b %R #[fg=colour247,bg=colour237] #h #{prefix_highlight}'
}

set_status_window() {
    tmux set -g window-status-separator ' '
    tmux set -g window-status-format "#[fg=colour235,bg=colour239,noreverse,nobold] #I 〉#W "
    tmux set -g window-status-current-format "#[fg=colour234,bg=colour179,noreverse,bold] #I 〉#W "
}

tmux_run "$(declare -F | awk '{print $NF}')"
