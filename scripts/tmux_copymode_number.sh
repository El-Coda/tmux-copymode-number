#!/usr/bin/env sh
#tmux_copymode_number.sh

#Enable debug tracing
#exec > /tmp/tmux_copymode_number_errors.log
#set -x  

set -e
if ! command -v nvim >/dev/null 2>&1; then
    tmux display-message "Error: nvim not found."
    exit 1
fi

PANE_ID=$1
CURRENT_WINDOW_ID=$2
CURRENT_DIR=$3

TMP_SESSION="copymode_temp"
#create temp session if it does not exist
if ! tmux has-session -t "$TMP_SESSION" 2>/dev/null; then
    tmux new-session -d -s "$TMP_SESSION"
fi
NO_LINES_IN_HISTORY=$(($(tmux capture-pane -t "$PANE_ID" -pe -S - -E 0 | wc -l)-1))
NO_LINES=$(tmux capture-pane -t "$PANE_ID" -pe -S - | wc -l)

CAPTURED_PANE=$(mktemp).tmux_captured_pane
tmux capture-pane -t "$PANE_ID" -pe -S - > $CAPTURED_PANE

#remove leading and trailing blank lines
sed -i -e '/./,$!d' -e ':a' -e '/^\n*$/{$d;N;ba}' $CAPTURED_PANE

#exec -a [tmux]: run nvim process under name [tmux]
#-u: specify config file
#--noplugin: ignore user config
#-c: run command on nvim start 
#set scrollback to No. lines in captured pane
#0.00${NO_LINES}: this is a hack to avoid a race condition where job exits before cat completes
#if you hit this race condition(i.e pane cuts off miday) remove one of the 0's after the .
tmux new-window -t "$TMP_SESSION" -d "
exec -a [tmux] nvim -u $CURRENT_DIR/scripts/config.vim --noplugin \
    -c 'set scrollback=$NO_LINES' \
    -c 'call jobstart(\"setterm -linewrap off;cat $CAPTURED_PANE&&sleep 0.00${NO_LINES}\",{ \
        \"term\":v:true,\
        \"on_exit\":function(\"OnExit\"),\
        \"stdout_buffered\":v:true, \
        \"current_dir\":\"${CURRENT_DIR}/scripts\", \
        \"current_window_id\":\"${CURRENT_WINDOW_ID}\",\
        \"temp_session\":\"${TMP_SESSION}\", \
        \"captured_pane\":\"${CAPTURED_PANE}\", \
        \"pane_id\":\"${PANE_ID}\",\
        \"no_lines_in_history\":$NO_LINES_IN_HISTORY\
    })'"


#stop window from exiting when nvim exits
tmux set-window-option -t "$CURRENT_WINDOW_ID" remain-on-exit on
