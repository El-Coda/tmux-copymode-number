#!/usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
tmux bind-key [ run-shell " $CURRENT_DIR/scripts/tmux_copymode_number.sh '#{pane_id}' '#{window_id}' $CURRENT_DIR "
