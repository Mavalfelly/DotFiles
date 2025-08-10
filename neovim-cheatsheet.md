# Neovim Cheat Sheet

## Understanding Vim Modes and Commands

Vim/Neovim operates in different modes. Understanding these modes is crucial for using the commands in this cheat sheet:

1. **Normal Mode** (Default)
   - This is where you start
   - Used for navigation and entering commands
   - Press `Esc` from any other mode to return here
   - Commands like `dd`, `yy`, `zM` are typed directly here (no `:` needed)

2. **Insert Mode**
   - Where you type/edit text
   - Enter from Normal mode using `i`, `a`, `o`, etc.
   - Exit back to Normal mode with `Esc`

3. **Visual Mode**
   - For selecting text
   - Enter from Normal mode using `v`, `V`, or `Ctrl-v`
   - Exit back to Normal mode with `Esc`

4. **Command Mode**
   - For executing commands that start with `:`
   - Enter from Normal mode by typing `:`
   - Examples: `:w`, `:q`, `:set number`

Reading Command Examples:
- `dd` means: in Normal mode, press `d` twice
- `:w` means: in Normal mode, type `:` then `w`
- `Ctrl-w` means: hold Ctrl and press w
- `<leader>` means: press the leader key (Space in LazyVim)
- `zM` means: in Normal mode, press `z` then `Shift+m`

## Basic Operations

### File Operations
- `:w` - Save current file
- `:w filename` - Save as new file
- `:q` - Quit (fails if unsaved changes)
- `:q!` - Quit and discard unsaved changes
- `:wq` or `:x` - Save and quit
- `:e filename` - Open file for editing
- `:saveas filename` - Save file as

### Navigation
- `h` - Move left
- `j` - Move down
- `k` - Move up
- `l` - Move right
- `w` - Jump to start of next word
- `b` - Jump to start of previous word
- `e` - Jump to end of word
- `0` - Jump to start of line
- `$` - Jump to end of line
- `gg` - Go to first line of document
- `G` - Go to last line of document
- `{number}G` - Go to line number
- `Ctrl-u` - Page up
- `Ctrl-d` - Page down
- `%` - Jump to matching parenthesis/bracket

### Text Selection
- `v` - Start visual mode (character selection)
- `V` - Start visual line mode (line selection)
- `Ctrl-v` - Start visual block mode
- `aw` - Select a word
- `ab` - Select a block with ()
- `aB` - Select a block with {}
- `at` - Select a block with tags
- `iw` - Select inner word
- `ib` - Select inner block with ()
- `iB` - Select inner block with {}
- `it` - Select inner tag

### Text Manipulation
- `yy` - Yank (copy) a line
- `yw` - Yank word
- `y$` - Yank to end of line
- `p` - Paste after cursor
- `P` - Paste before cursor
- `dd` - Delete (cut) a line
- `dw` - Delete word
- `D` - Delete to end of line
- `x` - Delete character at cursor
- `u` - Undo
- `Ctrl-r` - Redo

### Search and Replace
- `/pattern` - Search forward for pattern
- `?pattern` - Search backward for pattern
- `n` - Repeat search forward
- `N` - Repeat search backward
- `:%s/old/new/g` - Replace all old with new throughout file
- `:%s/old/new/gc` - Replace all old with new throughout file with confirmations

## Advanced Operations

### Multiple Files
- `:sp filename` - Open file in horizontal split
- `:vsp filename` - Open file in vertical split
- `Ctrl-ws` - Split window horizontally
- `Ctrl-wv` - Split window vertically
- `Ctrl-ww` - Switch between windows
- `Ctrl-wq` - Quit current window
- `Ctrl-wh` - Move to left window
- `Ctrl-wl` - Move to right window
- `Ctrl-wj` - Move to window below
- `Ctrl-wk` - Move to window above

### Text Objects
- `ci"` - Change inside quotes
- `ci{` - Change inside curly brackets
- `ci(` - Change inside parentheses
- `cit` - Change inside tags
- `di"` - Delete inside quotes
- `yi"` - Yank inside quotes

### Marks
- `ma` - Set mark 'a' at current position
- `'a` - Jump to line of mark 'a'
- `` `a `` - Jump to position of mark 'a'

### Macros
- `qa` - Record macro 'a'
- `q` - Stop recording macro
- `@a` - Run macro 'a'
- `@@` - Repeat last macro

### LazyVim Specific
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>e` - Toggle file explorer
- `gl` - Show diagnostic details
- `]d` - Next diagnostic
- `[d` - Previous diagnostic
- `gd` - Go to definition
- `gr` - Show references
- `K` - Show documentation

### Trouble.nvim Diagnostics
- `<leader>xx` - Show document diagnostics
- `<leader>xX` - Show workspace diagnostics
- `<leader>xL` - Show location list
- `<leader>xQ` - Show quickfix list

Inside Trouble window:
- `j/k` - Navigate up/down through diagnostics
- `<enter>` or `<tab>` - Jump to diagnostic location
- `q` - Close Trouble window
- `K` - Show full diagnostic message
- `r` - Refresh diagnostic list
- `o` - Jump to diagnostic and close window
- `p` - Preview diagnostic location

### Registers
- `"ay` - Yank into register 'a'
- `"ap` - Paste from register 'a'
- `:reg` - Show registers content

### Folding
- `zf` - Create fold
- `zo` - Open fold
- `zc` - Close fold
- `za` - Toggle fold
- `zR` - Open all folds
- `zM` - Close all folds

### Command Mode
- `Ctrl-f` - Edit command with normal mode
- `Ctrl-c` or `Esc` - Exit command mode
- `:!command` - Execute external command

Note: In LazyVim, the leader key is typically set to space. Commands starting with `<leader>` mean you should press space first.
