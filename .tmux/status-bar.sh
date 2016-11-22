#!/usr/bin/env bash

set_status_parameters() {
    tmux set -g status-left-length 32
    tmux set -g status-right-length 150
    tmux set -g status-interval 5
    tmux set -g window-status-separator ' '
    tmux set -g window-status-format "#[fg=colour235,bg=colour239,noreverse,nobold] #I 〉#W "
    tmux set -g window-status-current-format "#[fg=colour234,bg=colour172,noreverse,bold] #I 〉#W "
}

set_status_left() {
    local tmux_version="$(tmux -V | sed -r 's|[^0-9\.]||g')"

    if [[ "$(echo "${tmux_version} >= 2.0" | bc)" -eq 1 ]]; then
        tmux set -g status-left '#[fg=colour15,bg=colour166,bold] u #[fg=white,bg=colour234] '
    else
        tmux set -g status-left '#[fg=colour15,bg=colour166,bold] u '
    fi
}

set_status_right() {
    tmux set -g status-right '#[fg=colour237,bg=colour247] #(date +"%a") %d %b %R #[fg=colour247,bg=colour237] #h '
}

set_status_parameters
set_status_left
set_status_right
