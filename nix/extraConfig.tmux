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
set -g status-style bg='#44475a',fg='#bd93f9'

# status left
# are we controlling tmux or the content of the panes?
set -g status-left '#[bg=#f8f8f2]#[fg=#282a36]#{?client_prefix,#[bg=#ff79c6],} ☺ '

# are we zoomed into a pane?
set -ga status-left '#[bg=#44475a]#[fg=#ff79c6] #{?window_zoomed_flag, ↕  ,   }'

# window status
set-window-option -g window-status-style fg='#bd93f9',bg=default
set-window-option -g window-status-current-style fg='#ff79c6',bg='#282a36'
set -g window-status-current-format "#[fg=#44475a]#[bg=#bd93f9]#[fg=#f8f8f2]#[bg=#bd93f9] #I #W #[fg=#bd93f9]#[bg=#44475a]"
set -g window-status-format "#[fg=#f8f8f2]#[bg=#44475a]#I #W #[fg=#44475a] "
# status right
set -g status-right '#[fg=#8be9fd,bg=#44475a]#[fg=#44475a,bg=#8be9fd] #(tmux-mem-cpu-load -g 5 --interval 2) '
set -ga status-right '#[fg=#ff79c6,bg=#8be9fd]#[fg=#44475a,bg=#ff79c6] #(uptime | cut -f 4-5 -d " " | cut -f 1 -d ",") '
set -ga status-right '#[fg=#bd93f9,bg=#ff79c6]#[fg=#f8f8f2,bg=#bd93f9] %a %H:%M:%S #[fg=#6272a4]%Y-%m-%d '

# pane border
set -g pane-border-style fg='#6272a4'
set -g pane-active-border-style fg='#ff79c6'

# message text
set -g message-style bg='#44475a',fg='#8be9fd'

# Activity monitoring
setw -g monitor-activity on
set -g visual-activity on

# smart pane switching with awareness of vim splits http://robots.thoughtbot.com/seamlessly-navigate-vim-and-tmux-splits
is_vim='echo "#{pane_current_command}" | grep -iqE "(^|\/)g?(view|n?vim?)(diff)?$"'
bind -n C-h if-shell "$is_vim" "send-keys C-h" "select-pane -L"
bind -n C-j if-shell "$is_vim" "send-keys C-j" "select-pane -D"
bind -n C-k if-shell "$is_vim" "send-keys C-k" "select-pane -U"
bind -n C-l if-shell "$is_vim" "send-keys C-l" "select-pane -R"

# use PREFIX | to split window horizontally and PREFIX - to split vertically
bind | split-window -h
bind - split-window -v
