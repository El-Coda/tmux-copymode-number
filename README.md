# tmux-copymode-number


https://github.com/user-attachments/assets/f3b9f14a-09de-4d13-b174-696819a2d03c


tmux-copymode-number is hardly a plugin, its just a bunch scripts that display **relative line numbers in copy-mode**. it uses Neovim’s terminal with a specific configuration to simulate copy-mode.

## Dependencies

- **[Neovim](https://github.com/neovim/neovim)**

- **standard UNIX/Linux shell commands**
`wc` `cat` `sleep`

## Installation
### [TPM](https://github.com/tmux-plugins/tpm) (Recommended) :

```tmux
# Add to ~/.tmux.conf
set -g @plugin 'El-Coda/tmux-copymode-number'
```
And 

**prefix + I**

#### OR

### clone the folder to ~/.tmux/plugins :

```
#bash
git clone https://github.com/El-Coda/tmux-copymode-number  ~/.tmux/plugins/tmux-copymode-number
```
and 
```tmux
#Add to ~/.tmux.conf
run-shell ~/.tmux/plugins/tmux-copymode-number/tmux-copymode-number.tmux
```
and

```bash
#bash
tmux source-file ~/.tmux.conf
```


## Usages

**prefix + [**

**vim motions**

**y** yanks into clipboard

## Note 

this is by no means a finished project. help is welcomed

## warning 

there might be some weird behaivor regrading large `tmux capture-pane` output. 

if the pane is cut off midway you might have hit a race condition in jobstart with cat. 

take a look at `tmux_copymode_number.sh` comments
