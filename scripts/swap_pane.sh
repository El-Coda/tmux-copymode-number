#!/usr/bin/env sh
#swap_pane.sh

#Enable debug tracing
#exec > /tmp/tmux_copymode_number_after_errors.log
#set -x  
set -e

CURRENT_WINDOW_ID=$1
TMP_SESSION=$2
CAPTURED_PANE=$3
PANE_ID=$4
NVIM_PANE_ID=$5

#swap current pane with nvim pane
tmux swap-pane -s "$NVIM_PANE_ID" -t "$PANE_ID"

#swap the original pane with tmux pane and kill nvim pane 
#kill the temp session if no other copy-mode temp window exists
#set back the window options to normal
#and remove temp file
#on nvim exit
tmux set-hook -t "$NVIM_PANE_ID" pane-died "run-shell '\
    tmux swap-pane -s $PANE_ID -t $NVIM_PANE_ID; \
    tmux kill-pane -t $NVIM_PANE_ID
    PANE_COUNT=\$(tmux list-windows -t $TMP_SESSION 2>/dev/null | wc -l); \
    if [ \$PANE_COUNT -le 1 ]; then \
        tmux kill-session -t $TMP_SESSION 2>/dev/null || true; \
    fi; \
    tmux set-hook -u pane-died; \
    tmux set-window-option -t $CURRENT_WINDOW_ID remain-on-exit off; \
    rm $CAPTURED_PANE; \
'"

