#!/usr/bin/env bash

# set -g prefix §
map_control_key() {
    tmux set -g prefix C-s
    tmux unbind C-b
    tmux bind C-s send-prefix
}

# Force a reload of the config file
map_reload() {
    tmux unbind r
    tmux bind r source-file ~/.tmux.conf \; display "Reloaded ~/.tmux.conf"
}

map_pane_navigation() {
    # Quick pane cycling
    tmux unbind ^A
    tmux bind ^A select-pane -t :.+

    # More straight forward key bindings for splitting
    tmux unbind %
    tmux bind \| split-window -h
    tmux bind h split-window -h
    tmux unbind '"'
    tmux bind - split-window -v
    tmux bind v split-window -v

    # Moving between panes
    tmux bind h select-pane -L
    tmux bind j select-pane -D
    tmux bind k select-pane -U
    tmux bind l select-pane -R

    # Pane resizing
    tmux bind-key H resize-pane -U 15
    tmux bind-key J resize-pane -D 15
    tmux bind-key K resize-pane -L 15
    tmux bind-key L resize-pane -R 15
}

map_window_management() {
    # Better name management
    tmux bind c new-window
    tmux bind , command-prompt "rename-window '%%'"
}

map_copy_paste() {
    # Vi-style copy paste
    tmux unbind [
    tmux bind Escape copy-mode
    tmux unbind p
    tmux bind p paste-buffer
    tmux bind-key -t vi-copy 'v' begin-selection
    tmux bind-key -t vi-copy 'y' copy-selection
}

map_clear() {
    # CLEAR
    tmux bind -n C-k send-keys "clear; tmux clear-history" \; send-keys "Enter"
}

main() {
    map_clear
    map_control_key
    map_copy_paste
    map_pane_navigation
    map_reload
    map_window_management
}

main
