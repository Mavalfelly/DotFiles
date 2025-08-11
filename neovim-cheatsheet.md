# Enhanced LazyVim Cheat Sheet

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

## Window Management

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

## LSP and Diagnostics (Error Handling)

### Accessing LSP Errors and Diagnostics
When you see underlines in your code, these are LSP diagnostics (errors, warnings, hints, info):

- `gl` - Show diagnostic details (hover over error)
- `K` - Show documentation/hover information
- `]d` - Jump to next diagnostic
- `[d` - Jump to previous diagnostic
- `:lua vim.diagnostic.open_float()` - Open diagnostic in floating window
- `:lua vim.diagnostic.setloclist()` - Put diagnostics in location list

### LSP Commands
- `gd` - Go to definition
- `gr` - Show references
- `gi` - Go to implementation
- `gD` - Go to declaration
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol
- `<leader>f` - Format current file/selection

### Mason LSP Management
- `:Mason` - Open Mason installer for LSP servers
- `:MasonInstall <server>` - Install specific LSP server
- `:MasonUninstall <server>` - Uninstall specific LSP server
- `:MasonLog` - View Mason logs

## Telescope (Fuzzy Finder)

### File Finding
- `<leader>ff` - Find files
- `<leader>fg` - Live grep (search in files)
- `<leader>fb` - Show open buffers
- `<leader>fh` - Help tags
- `<leader>fr` - Recent files (oldfiles)
- `<leader>fc` - Available commands

### Telescope Navigation (in picker)
- `Ctrl-j` - Move down in results
- `Ctrl-k` - Move up in results
- `Ctrl-c` or `Esc` - Close telescope
- `Enter` - Select item
- `Ctrl-x` - Open in horizontal split
- `Ctrl-v` - Open in vertical split
- `Ctrl-t` - Open in new tab

## Neo-tree (File Explorer)

### File Explorer Commands
- `<leader>e` - Toggle file explorer
- `<leader>o` - Focus file explorer

### Neo-tree Navigation (when focused)
- `Enter` - Open file/expand directory
- `a` - Add file/directory
- `d` - Delete file/directory
- `r` - Rename file/directory
- `c` - Copy file/directory
- `m` - Move/cut file/directory
- `p` - Paste
- `R` - Refresh
- `H` - Toggle hidden files
- `<` - Previous source (filesystem, buffers, git)
- `>` - Next source

## Git Integration (Gitsigns)

### Git Navigation
- `]c` - Next git hunk (change)
- `[c` - Previous git hunk (change)

### Git Actions
- `<leader>hs` - Stage hunk
- `<leader>hr` - Reset hunk
- `<leader>hS` - Stage entire buffer
- `<leader>hu` - Undo stage hunk
- `<leader>hR` - Reset entire buffer
- `<leader>hp` - Preview hunk
- `<leader>hb` - Show blame line (full)
- `<leader>tb` - Toggle current line blame
- `<leader>hd` - Diff this file

## Debugging (DAP)

### Debug Commands
- `<leader>db` - Toggle breakpoint
- `<leader>dc` - Continue/start debugging
- `<leader>ds` - Step over
- `<leader>di` - Step into
- `<leader>do` - Step out
- `<leader>dr` - Open debug REPL

### DAP UI
- Debug UI opens automatically when debugging starts
- Shows variables, call stack, breakpoints, and console

## Trouble (Error Management)

### Trouble Commands (v3 API)
- `<leader>xx` - Toggle diagnostics (all workspace errors/warnings)
- `<leader>xX` - Toggle buffer diagnostics (current file only)
- `<leader>xL` - Toggle location list
- `<leader>xQ` - Toggle quickfix list
- `<leader>cs` - Toggle symbols (document outline)
- `<leader>cl` - Toggle LSP definitions/references
- `]t` - Next trouble item (jump to next error)
- `[t` - Previous trouble item (jump to previous error)

### Trouble Window Navigation (when Trouble is open)
- `Enter` or `<cr>` - Jump to item
- `o` - Jump to item and close Trouble
- `<C-s>` - Jump to item in split
- `<C-v>` - Jump to item in vertical split
- `q` or `<Esc>` - Close Trouble window
- `?` - Show help
- `r` - Refresh items
- `R` - Toggle auto-refresh

### Trouble Window Movement
- `j` or `}` or `]]` - Next item
- `k` or `{` or `[[` - Previous item
- `dd` - Delete item (where applicable)
- `i` - Inspect item details
- `p` - Preview item
- `P` - Toggle preview mode

### Trouble Folding
- `zo` - Open fold
- `zO` - Open fold recursively
- `zc` - Close fold
- `zC` - Close fold recursively
- `za` - Toggle fold
- `zA` - Toggle fold recursively
- `zm` - Fold more
- `zM` - Close all folds
- `zr` - Fold reduce
- `zR` - Open all folds
- `zx` - Update folds
- `zX` - Update all folds

### Advanced Trouble Commands
- `:Trouble diagnostics` - Open diagnostics
- `:Trouble diagnostics filter.buf=0` - Current buffer diagnostics only
- `:Trouble symbols` - Document symbols/outline
- `:Trouble lsp` - LSP references/definitions
- `:Trouble lsp_references` - LSP references only
- `:Trouble lsp_definitions` - LSP definitions only
- `:Trouble lsp_implementations` - LSP implementations
- `:Trouble lsp_type_definitions` - LSP type definitions
- `:Trouble lsp_document_symbols` - Document symbols
- `:Trouble qflist` - Quickfix list
- `:Trouble loclist` - Location list

### Trouble API Functions (for custom keymaps)
- `require("trouble").toggle("diagnostics")` - Toggle diagnostics
- `require("trouble").open("diagnostics")` - Open diagnostics  
- `require("trouble").close()` - Close Trouble
- `require("trouble").next()` - Go to next item
- `require("trouble").prev()` - Go to previous item
- `require("trouble").first()` - Go to first item
- `require("trouble").last()` - Go to last item

## Comments

### Comment Commands
- `gcc` - Toggle line comment
- `gbc` - Toggle block comment
- `gc` + motion - Comment motion (e.g., `gcap` for paragraph)
- In visual mode: `gc` - Comment selection

## Surround (nvim-surround)

### Surround Commands
- `ys{motion}{char}` - Add surround (e.g., `ysiw"` surrounds word with quotes)
- `cs{old}{new}` - Change surround (e.g., `cs"'` changes quotes to apostrophes)
- `ds{char}` - Delete surround (e.g., `ds"` removes quotes)
- `S{char}` - Surround selection (in visual mode)

### Common Surround Examples
- `ysiw"` - Surround word with quotes
- `ysa"` - Surround around quotes
- `cs"'` - Change double quotes to single quotes
- `ds"` - Delete quotes around cursor
- `dst` - Delete surrounding HTML/XML tag

## Auto-completion (nvim-cmp)

### Completion Navigation
- `Tab` - Next completion item
- `Shift-Tab` - Previous completion item
- `Ctrl-Space` - Trigger completion
- `Ctrl-e` - Abort completion
- `Enter` - Confirm selection
- `Ctrl-b` - Scroll docs up
- `Ctrl-f` - Scroll docs down

## Auto-pairs

### Auto-pair Features
- Automatic closing of brackets, quotes, etc.
- `Alt-e` - Fast wrap (with configured pattern)

## Bufferline (Buffer Tabs)

### Buffer Navigation
- `gb` - Pick buffer (LazyVim default)
- `]b` - Next buffer
- `[b` - Previous buffer
- `<leader>bd` - Delete buffer
- `<leader>bD` - Delete buffer (force)

## Formatting (Conform)

### Format Commands
- `<leader>cf` - Format current file or selection
- Format on save is enabled by default

## Todo Comments

### Todo Navigation
- `]t` - Next todo comment
- `[t` - Previous todo comment
- `:TodoTrouble` - Show todos in Trouble
- `:TodoTelescope` - Search todos with Telescope

### Todo Keywords
- `TODO:` - General todo
- `HACK:` - Hack or workaround
- `WARN:` - Warning
- `PERF:` - Performance issue
- `NOTE:` - General note
- `TEST:` - Test related
- `FIX:` or `FIXME:` - Fix needed

## Which-key Help

### Help System
- `<leader>` (wait) - Shows available key bindings
- `:WhichKey` - Show all key mappings
- Most leader key combinations will show you available options if you wait

## LazyVim and Lazy Plugin Manager

### Plugin Management Commands
- `:Lazy` - Open Lazy plugin manager
- `:LazyExtras` - Manage LazyVim extras  
- `:LazyHealth` - Check plugin health
- `:LazyInstall` - Install missing plugins
- `:LazyUpdate` - Update plugins
- `:LazySync` - Run install, clean and update
- `:LazyClean` - Clean plugins that are no longer needed
- `:LazyCheck` - Check for updates and show the log
- `:LazyLog` - Show recent updates
- `:LazyRestore` - Updates all plugins to the state in the lockfile
- `:LazyProfile` - Show detailed profiling
- `:LazyDebug` - Show debug information
- `:LazyHelp` - Toggle help
- `:LazyHome` - Go to plugin home page
- `:LazyClear` - Clear finished tasks
- `:LazyLoad {plugins}` - Load specific plugins

### Lazy Manager Navigation (when `:Lazy` is open)
- `Enter` - Execute action or open plugin details
- `I` - Install plugin
- `U` - Update plugin  
- `S` - Sync (install, clean, update)
- `X` - Clean (remove unused plugins)
- `C` - Check for updates
- `L` - View logs
- `R` - Restore from lockfile
- `P` - Profile plugin startup time
- `D` - Debug plugin issues
- `H` - Toggle help
- `?` - Toggle help
- `q` or `<Esc>` - Close Lazy manager
- `<C-c>` - Cancel current operation
- `r` - Reload plugin (during development)
- `d` - Show diff for updates
- `g?` - Help for current plugin
- `gx` - Open plugin homepage in browser

### LazyVim Keymaps
- `<leader>l` - Lazy plugin manager
- `<leader>L` - LazyVim changelog
- `<leader>ft` - Terminal (toggle)
- `<leader>fT` - Terminal (root dir)

### Lazy Loading Information
- Plugins are lazy-loaded by default for better startup time
- Use `:LazyProfile` to see startup performance
- Check loading order and timing with detailed profiling

## Advanced Text Objects (with treesitter)

### Treesitter Text Objects
- `af` - Around function
- `if` - Inside function
- `ac` - Around class
- `ic` - Inside class
- `aa` - Around argument
- `ia` - Inside argument

### Movement
- `]m` - Next method start
- `]M` - Next method end
- `[m` - Previous method start
- `[M` - Previous method end
- `]c` - Next class start
- `]C` - Next class end
- `[c` - Previous class start
- `[C` - Previous class end

## Tips and Tricks

### Useful Combinations
- `<leader>ff` then type filename - Quick file opening
- `<leader>fg` then search term - Project-wide search
- `gd` then `Ctrl-o` - Go to definition then back
- `:Mason` to install language servers for your projects
- Use `K` on any symbol to get documentation
- `]d` and `[d` to navigate through errors quickly
- `<leader>ca` for quick fixes and code actions

### Diagnostic Symbols
- Error: Usually shown with red underline and error icon
- Warning: Yellow/orange underline and warning icon  
- Info: Blue underline and info icon
- Hint: Gray/subtle underline and hint icon

Note: In LazyVim, the leader key is Space. When you see `<leader>` in commands, press the spacebar first, then the following keys. The which-key plugin will show you available options after pressing the leader key.