# Setup 'v' to begin selection as in Vim
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi y send-keys -X copy-selection
bind-key -T copy-mode-vi r send-keys -X rectangle-toggle

# Update default binding of `Enter` to also use copy-pipe
unbind-key -T copy-mode-vi Enter

# ----------------------
# Status Bar
# -----------------------
set-option -g status on                # turn the status bar on
set -g status-interval 5               # set update frequencey (default 15 seconds)
set-option -g allow-rename off         # don't automatically rename panels

# color status bar
set -g status-bg colour235
set -g status-fg yellow #yellow
set-window-option -g window-status-style dim
set -g status-fg white

# show session name, window & pane number, date and time on right side of status bar
set -g status-right-length 60
set -g status-right "%b %d %H:%M"

# highlight current window
set-window-option -g window-status-current-style fg=black
set-window-option -g window-status-current-style bg=white

# set color of active pane
set-window-option -g window-status-current-style fg=black
set -g status-left-length 30
set -g status-interval 60

# Activity monitoring
setw -g monitor-activity on
set -g visual-activity on

# Highlighting Current Window Using Specified Colour
set-window-option -g window-status-current-style bg=yellow

# smart pane switching with awareness of vim splits http://robots.thoughtbot.com/seamlessly-navigate-vim-and-tmux-splits
is_vim='echo "#{pane_current_command}" | grep -iqE "(^|\/)g?(view|n?vim?)(diff)?$"'
bind -n C-h if-shell "$is_vim" "send-keys C-h" "select-pane -L"
bind -n C-j if-shell "$is_vim" "send-keys C-j" "select-pane -D"
bind -n C-k if-shell "$is_vim" "send-keys C-k" "select-pane -U"
bind -n C-l if-shell "$is_vim" "send-keys C-l" "select-pane -R"

# use PREFIX | to split window horizontally and PREFIX - to split vertically
bind | split-window -h
bind - split-window -v
