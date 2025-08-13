# Essential Vim/Neovim Cheat Sheet

## Understanding Vim Modes

Vim/Neovim operates in different modes. Understanding these modes is crucial:

1. **Normal Mode** (Default)
   - This is where you start
   - Used for navigation and entering commands
   - Press `Esc` from any other mode to return here
   - Commands like `dd`, `yy`, `w` are typed directly here (no `:` needed)

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

## Core File Operations

### Saving and Quitting
- `:w` - Save current file
- `:w filename` - Save as new file
- `:q` - Quit (fails if unsaved changes)
- `:q!` - Quit and discard unsaved changes
- `:wq` or `:x` or `ZZ` - Save and quit
- `:e filename` - Open file for editing
- `:e!` - Reload current file (discard changes)

## Essential Movement

### Basic Movement
- `h` - Move left
- `j` - Move down  
- `k` - Move up
- `l` - Move right

### Word Movement
- `w` - Jump to start of next word
- `W` - Jump to start of next WORD (ignores punctuation)
- `b` - Jump to start of previous word
- `B` - Jump to start of previous WORD
- `e` - Jump to end of current/next word
- `E` - Jump to end of current/next WORD
- `ge` - Jump to end of previous word

### Line Movement
- `0` - Jump to start of line (column 0)
- `^` - Jump to first non-blank character of line
- `$` - Jump to end of line
- `g_` - Jump to last non-blank character of line

### Document Movement
- `gg` - Go to first line of document
- `G` - Go to last line of document
- `{number}G` - Go to line number (e.g., `25G` goes to line 25)
- `{number}gg` - Same as above
- `:number` - Go to line number (e.g., `:25`)

### Page Movement
- `Ctrl-f` - Page down (forward)
- `Ctrl-b` - Page up (backward)
- `Ctrl-d` - Half page down
- `Ctrl-u` - Half page up
- `H` - Move to top of screen (High)
- `M` - Move to middle of screen (Middle)
- `L` - Move to bottom of screen (Low)

### Character Search
- `f{char}` - Find next occurrence of character in line
- `F{char}` - Find previous occurrence of character in line
- `t{char}` - Move to just before next occurrence of character
- `T{char}` - Move to just after previous occurrence of character
- `;` - Repeat last f, F, t, or T command
- `,` - Repeat last f, F, t, or T command in opposite direction

### Matching
- `%` - Jump to matching parenthesis/bracket/brace
- `*` - Search for word under cursor (forward)
- `#` - Search for word under cursor (backward)

## Text Selection (Visual Mode)

### Visual Mode Types
- `v` - Character-wise visual mode
- `V` - Line-wise visual mode
- `Ctrl-v` - Block-wise visual mode
- `gv` - Reselect last visual selection

### Text Objects (use with d, y, c, v)
#### Word Objects
- `iw` - Inner word (word without surrounding spaces)
- `aw` - A word (word with surrounding spaces)
- `iW` - Inner WORD (WORD without surrounding spaces)
- `aW` - A WORD (WORD with surrounding spaces)

#### Sentence and Paragraph Objects
- `is` - Inner sentence
- `as` - A sentence
- `ip` - Inner paragraph
- `ap` - A paragraph

#### Bracket/Quote Objects
- `i(` or `ib` - Inside parentheses
- `a(` or `ab` - Around parentheses (includes parentheses)
- `i{` or `iB` - Inside curly braces
- `a{` or `aB` - Around curly braces
- `i[` - Inside square brackets
- `a[` - Around square brackets
- `i<` - Inside angle brackets
- `a<` - Around angle brackets
- `i"` - Inside double quotes
- `a"` - Around double quotes
- `i'` - Inside single quotes
- `a'` - Around single quotes
- `i`` ` - Inside backticks
- `a`` ` - Around backticks

#### Tag Objects (HTML/XML)
- `it` - Inside tag
- `at` - Around tag

## Text Manipulation

### Copy (Yank)
- `yy` or `Y` - Yank entire line
- `yw` - Yank word
- `y$` - Yank to end of line
- `y0` - Yank to beginning of line
- `yiw` - Yank inner word
- `yaw` - Yank a word (with spaces)
- `yap` - Yank a paragraph
- `yi"` - Yank inside quotes

### Paste
- `p` - Paste after cursor/below current line
- `P` - Paste before cursor/above current line
- `gp` - Paste and move cursor to end of pasted text
- `gP` - Same as gp but paste before

### Delete (Cut)
- `dd` - Delete entire line
- `dw` - Delete word
- `d$` or `D` - Delete to end of line
- `d0` - Delete to beginning of line
- `diw` - Delete inner word
- `daw` - Delete a word (with spaces)
- `dap` - Delete a paragraph
- `di"` - Delete inside quotes
- `x` - Delete character under cursor
- `X` - Delete character before cursor

### Change (Delete and Insert)
- `cc` or `S` - Change entire line
- `cw` - Change word
- `c$` or `C` - Change to end of line
- `ciw` - Change inner word
- `caw` - Change a word (with spaces)
- `ci"` - Change inside quotes
- `cit` - Change inside HTML/XML tags
- `s` - Change character (delete char and enter insert mode)

### Replace
- `r{char}` - Replace single character
- `R` - Enter replace mode (overwrite characters)
- `~` - Toggle case of character under cursor
- `g~iw` - Toggle case of word
- `guiw` - Make word lowercase
- `gUiw` - Make word uppercase

## Undo and Redo

### Basic Undo/Redo
- `u` - Undo last change
- `Ctrl-r` - Redo
- `U` - Undo all changes on current line
- `.` - Repeat last change

### Advanced Undo
- `:earlier 10m` - Go to state 10 minutes ago
- `:later 10m` - Go to state 10 minutes later
- `:undolist` - Show undo tree
- `g-` - Go to older text state
- `g+` - Go to newer text state

## Search and Replace

### Basic Search
- `/pattern` - Search forward for pattern
- `?pattern` - Search backward for pattern
- `n` - Go to next search match
- `N` - Go to previous search match
- `/` - Repeat last search forward
- `?` - Repeat last search backward

### Search Options
- `/pattern\c` - Case insensitive search
- `/pattern\C` - Case sensitive search
- `:set ignorecase` - Make all searches case insensitive
- `:set smartcase` - Case insensitive unless pattern has uppercase

### Replace (Substitute)
- `:s/old/new/` - Replace first occurrence in current line
- `:s/old/new/g` - Replace all occurrences in current line
- `:%s/old/new/g` - Replace all occurrences in entire file
- `:%s/old/new/gc` - Replace all with confirmation
- `:5,10s/old/new/g` - Replace in lines 5-10
- `:'<,'>s/old/new/g` - Replace in visual selection

### Special Replace Characters
- `&` - Represents the matched pattern
- `\1`, `\2`, etc. - Backreferences to captured groups
- `~` - Use previous replacement string

## Window and Buffer Management

### Window Splitting
- `:sp` or `:split` - Split window horizontally
- `:vsp` or `:vsplit` - Split window vertically
- `:sp filename` - Split and open file
- `:vsp filename` - Vertical split and open file

### Window Navigation
- `Ctrl-w h` - Move to left window
- `Ctrl-w j` - Move to window below
- `Ctrl-w k` - Move to window above
- `Ctrl-w l` - Move to right window
- `Ctrl-w w` - Cycle through windows
- `Ctrl-w p` - Go to previous window

### Window Resizing
- `Ctrl-w =` - Make all windows equal size
- `Ctrl-w +` - Increase window height
- `Ctrl-w -` - Decrease window height
- `Ctrl-w >` - Increase window width
- `Ctrl-w <` - Decrease window width
- `Ctrl-w |` - Maximize window width
- `Ctrl-w _` - Maximize window height

### Window Management
- `Ctrl-w q` - Close current window
- `Ctrl-w o` - Close all other windows
- `Ctrl-w T` - Move current window to new tab

### Buffer Operations
- `:ls` or `:buffers` - List all buffers
- `:b{number}` - Switch to buffer number
- `:b{partial_name}` - Switch to buffer by partial name
- `:bn` or `:bnext` - Next buffer
- `:bp` or `:bprevious` - Previous buffer
- `:bd` - Delete (close) current buffer
- `:bd {number}` - Delete specific buffer
- `Ctrl-^` or `Ctrl-6` - Switch to alternate buffer

## Tab Management

### Tab Operations
- `:tabnew` or `:tabe` - Create new tab
- `:tabnew filename` - Open file in new tab
- `gt` or `:tabn` - Next tab
- `gT` or `:tabp` - Previous tab
- `{number}gt` - Go to tab number
- `:tabc` - Close current tab
- `:tabo` - Close all other tabs
- `:tabs` - List all tabs

## Marks and Jumps

### Setting and Using Marks
- `m{letter}` - Set mark (a-z for file-local, A-Z for global)
- `'{mark}` - Jump to line of mark
- `` `{mark} `` - Jump to exact position of mark
- `''` - Jump to line of last jump
- ``` `` ``` - Jump to exact position of last jump

### Special Marks
- `'.` - Jump to last change
- `'^` - Jump to last insertion
- `'[` - Jump to beginning of last change/yank
- `']` - Jump to end of last change/yank

### Jump List
- `Ctrl-o` - Go back in jump list
- `Ctrl-i` - Go forward in jump list
- `:jumps` - Show jump list

## Macros

### Recording and Playing Macros
- `q{letter}` - Start recording macro into register {letter}
- `q` - Stop recording macro
- `@{letter}` - Play macro from register {letter}
- `@@` - Repeat last macro
- `{number}@{letter}` - Play macro {number} times

### Macro Tips
- `qA` - Append to existing macro in register 'a'
- `:let @a='...'` - Edit macro in register 'a'

## Registers

### Using Registers
- `"{register}` - Use specific register for next command
- `"ay` - Yank into register 'a'
- `"ap` - Paste from register 'a'
- `"Ay` - Append to register 'a'
- `:reg` or `:registers` - Show all register contents
- `:reg a` - Show contents of register 'a'

### Special Registers
- `""` - Unnamed register (default)
- `"0` - Yank register (last yanked text)
- `"1-"9` - Delete registers (last 9 deletions)
- `"-` - Small delete register
- `"+` - System clipboard (may need +clipboard feature)
- `"*` - Selection clipboard (may need +clipboard feature)
- `"/` - Last search pattern
- `":` - Last command
- `".` - Last inserted text
- `"%` - Current filename
- `"#` - Alternate filename

## Folding

### Manual Folding
- `zf{motion}` - Create fold (e.g., `zfap` folds a paragraph)
- `zf'a` - Create fold from current line to mark 'a'
- `{number}zF` - Create fold over {number} lines

### Fold Navigation
- `zo` - Open fold under cursor
- `zO` - Open fold under cursor recursively
- `zc` - Close fold under cursor
- `zC` - Close fold under cursor recursively
- `za` - Toggle fold under cursor
- `zA` - Toggle fold under cursor recursively

### Global Fold Operations
- `zR` - Open all folds
- `zM` - Close all folds
- `zr` - Reduce fold level (open more folds)
- `zm` - Increase fold level (close more folds)
- `zi` - Toggle folding on/off

### Fold Movement
- `zj` - Move to start of next fold
- `zk` - Move to end of previous fold
- `[z` - Move to start of current open fold
- `]z` - Move to end of current open fold

### Fold Settings
- `:set foldmethod=manual` - Manual folding
- `:set foldmethod=indent` - Fold by indentation
- `:set foldmethod=syntax` - Fold by syntax
- `:set foldmethod=marker` - Fold by markers

## Command Line Operations

### Command History
- `:` then `↑/↓` - Navigate command history
- `q:` - Open command history window
- `Ctrl-f` (in command mode) - Switch to command history window

### Command Line Editing
- `Ctrl-a` - Move to beginning of line
- `Ctrl-e` - Move to end of line
- `Ctrl-w` - Delete word before cursor
- `Ctrl-u` - Delete entire line

### External Commands
- `:!command` - Execute external command
- `:!!` - Repeat last external command
- `:r !command` - Insert output of command into buffer
- `:{range}!command` - Filter lines through command

## Advanced Movement Patterns

### Paragraph and Section Movement
- `{` - Move to previous blank line (paragraph)
- `}` - Move to next blank line (paragraph)
- `[[` - Move to previous section (often functions)
- `]]` - Move to next section
- `[]` - Move to end of previous section
- `][` - Move to end of current section

### Sentence Movement
- `(` - Move to previous sentence
- `)` - Move to next sentence

## Indentation

### Manual Indentation
- `>>` - Indent current line
- `<<` - Unindent current line
- `>{motion}` - Indent lines covered by motion
- `<{motion}` - Unindent lines covered by motion
- `{number}>>` - Indent {number} lines
- `={motion}` - Auto-indent lines covered by motion
- `==` - Auto-indent current line

### Visual Mode Indentation
- `>` - Indent selection
- `<` - Unindent selection
- `=` - Auto-indent selection

### Indentation Settings
- `:set tabstop=4` - Set tab width to 4 spaces
- `:set shiftwidth=4` - Set indent width to 4 spaces
- `:set expandtab` - Use spaces instead of tabs
- `:set autoindent` - Copy indent from current line
- `:set smartindent` - Smart indentation for code

## Line Operations

### Line Manipulation
- `J` - Join current line with next line
- `gJ` - Join lines without adding space
- `o` - Open new line below and enter insert mode
- `O` - Open new line above and enter insert mode
- `{number}o` - Open {number} new lines below

### Line Sorting
- `:sort` - Sort lines
- `:sort!` - Sort lines in reverse
- `:sort u` - Sort and remove duplicates
- `:'<,'>sort` - Sort visual selection

## Settings and Configuration

### Display Settings
- `:set number` - Show line numbers
- `:set relativenumber` - Show relative line numbers
- `:set nonumber` - Hide line numbers
- `:set list` - Show invisible characters
- `:set nolist` - Hide invisible characters
- `:set wrap` - Enable line wrapping
- `:set nowrap` - Disable line wrapping

### Search Settings
- `:set hlsearch` - Highlight search results
- `:set nohlsearch` or `:noh` - Turn off search highlighting
- `:set incsearch` - Show matches while typing
- `:set ignorecase` - Case insensitive search
- `:set smartcase` - Case sensitive if uppercase present

### File Settings
- `:set autoread` - Auto reload changed files
- `:set autowrite` - Auto save before certain commands
- `:set hidden` - Allow switching buffers without saving

## Tips and Advanced Techniques

### Efficient Text Editing
- `ciw` - Change word (very common)
- `ca"` - Change around quotes
- `da(` - Delete around parentheses
- `yi}` - Yank inside braces
- `vip` - Select paragraph
- `gqap` - Format paragraph

### Repeating Operations
- `.` - Repeat last change (extremely useful)
- `&` - Repeat last substitute command
- `n.` - Find next and repeat change
- `@:` - Repeat last command

### Multiple Operations
- `5dd` - Delete 5 lines
- `3w` - Move 3 words forward
- `2f"` - Find second quote on line
- `4>>` - Indent 4 lines

### Quick Fixes
- `gwap` - Reformat paragraph
- `xp` - Swap two characters
- `ddp` - Swap two lines
- `gUU` - Make entire line uppercase
- `guu` - Make entire line lowercase

This cheat sheet focuses on native Vim commands that work in any Vim/Neovim installation without plugins. These commands form the foundation of efficient text editing in Vim.