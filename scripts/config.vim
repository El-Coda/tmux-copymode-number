autocmd TermOpen * set nowrap number relativenumber
highlight Normal guibg=NONE ctermbg=NONE

nnoremap <buffer> q :qa!<CR>
set termguicolors 
set t_Co=256
set laststatus=0

set noshowcmd 
set noruler 
set noshowmode 

set cmdheight=0
set scrolloff=0
set smartcase
set clipboard+=unnamedplus

function! OnExit(job_id, exit_code, event) dict abort
    if a:exit_code == 0
        let no_lines_in_history = self.no_lines_in_history
        let current_dir = self.current_dir
        let current_window_id = self.current_window_id
        let temp_session = self.temp_session
        let captured_pane = self.captured_pane
        let pane_id = self.pane_id
        call timer_start(20, { -> s:FinalizeView(no_lines_in_history, current_dir, current_window_id, temp_session, captured_pane, pane_id)})
    else
        echo "Error loading tmux history. Job exited with code:" a:exit_code
    endif
endfunction

function! s:FinalizeView(no_lines_in_history, current_dir, current_window_id, temp_session, captured_pane, pane_id)
    "hide pane history
    call cursor(a:no_lines_in_history, 0)    
    execute 'normal! zt'
    
    "remove [Process exited 0]
    execute '$'
    execute '?\[Process exited 0\]'
    set modifiable
    execute 'd'
    set nomodifiable

    "go to last none-blank line 
    execute '?^.'

    "remove search highlight
    execute 'noh'
    
    "swap pane
    let swap_pane = a:current_dir."/swap_pane.sh"
    call jobstart([swap_pane, a:current_window_id, a:temp_session, a:captured_pane, a:pane_id, $TMUX_PANE],{})
endfunction
