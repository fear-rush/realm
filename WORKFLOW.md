# Complete Development Environment Documentation

## Overview

This documentation covers your complete Nix-based development environment on macOS (Apple Silicon), including Neovim configuration, terminal tools, and common workflows.

---

# Table of Contents

1. [Installed Packages & References](#1-installed-packages--references)
2. [Neovim Workflow Guide](#2-neovim-workflow-guide)
3. [Terminal Tools Workflow](#3-terminal-tools-workflow)
4. [Complete Keybindings Reference](#4-complete-keybindings-reference)
5. [Nix Internals & Development Workflows](#5-nix-internals--development-workflows)

---

# 1. Installed Packages & References

## 1.1 Neovim Plugins

| Plugin | Description | Reference |
|--------|-------------|-----------|
| **nixvim** | Nix-based Neovim configuration framework | [GitHub](https://github.com/nix-community/nixvim) |
| **catppuccin** | Soothing pastel color scheme (Mocha flavor) | [GitHub](https://github.com/catppuccin/nvim) |
| **lualine.nvim** | Fast and customizable status line | [GitHub](https://github.com/nvim-lualine/lualine.nvim) |
| **bufferline.nvim** | VSCode-like buffer tabs | [GitHub](https://github.com/akinsho/bufferline.nvim) |
| **neo-tree.nvim** | File explorer with git integration | [GitHub](https://github.com/nvim-neo-tree/neo-tree.nvim) |
| **telescope.nvim** | Fuzzy finder for files, grep, and more | [GitHub](https://github.com/nvim-telescope/telescope.nvim) |
| **nvim-treesitter** | Advanced syntax highlighting | [GitHub](https://github.com/nvim-treesitter/nvim-treesitter) |
| **toggleterm.nvim** | Toggleable floating terminal | [GitHub](https://github.com/akinsho/toggleterm.nvim) |
| **gitsigns.nvim** | Git signs and hunk operations | [GitHub](https://github.com/lewis6991/gitsigns.nvim) |
| **which-key.nvim** | Keybinding help popup | [GitHub](https://github.com/folke/which-key.nvim) |
| **trouble.nvim** | Diagnostics and quickfix panel | [GitHub](https://github.com/folke/trouble.nvim) |
| **flash.nvim** | Quick navigation with labels | [GitHub](https://github.com/folke/flash.nvim) |
| **blink-cmp** | Fast completion engine | [GitHub](https://github.com/Saghen/blink.cmp) |
| **conform.nvim** | Code formatter | [GitHub](https://github.com/stevearc/conform.nvim) |
| **comment.nvim** | Toggle comments | [GitHub](https://github.com/numToStr/Comment.nvim) |
| **nvim-surround** | Surround text with pairs | [GitHub](https://github.com/kylechui/nvim-surround) |
| **todo-comments.nvim** | Highlight TODO/FIXME comments | [GitHub](https://github.com/folke/todo-comments.nvim) |
| **treesj** | Split/join code blocks | [GitHub](https://github.com/Wansmer/treesj) |
| **indent-blankline** | Visual indent guides | [GitHub](https://github.com/lukas-reineke/indent-blankline.nvim) |
| **fidget.nvim** | LSP progress notifications | [GitHub](https://github.com/j-hui/fidget.nvim) |
| **alpha-nvim** | Dashboard/start screen | [GitHub](https://github.com/goolord/alpha-nvim) |
| **web-devicons** | File type icons | [GitHub](https://github.com/nvim-tree/nvim-web-devicons) |

## 1.2 LSP Servers (Language Support)

| Language | Server | Reference |
|----------|--------|-----------|
| TypeScript/JavaScript | ts_ls | [GitHub](https://github.com/typescript-language-server/typescript-language-server) |
| Python | pyright | [GitHub](https://github.com/microsoft/pyright) |
| Python (linting) | ruff | [GitHub](https://github.com/astral-sh/ruff) |
| Rust | rust-analyzer | [GitHub](https://github.com/rust-lang/rust-analyzer) |
| Go | gopls | [GitHub](https://github.com/golang/tools/tree/master/gopls) |
| C/C++ | clangd | [LLVM](https://clangd.llvm.org/) |
| Nix | nil | [GitHub](https://github.com/oxalica/nil) |
| Lua | lua_ls | [GitHub](https://github.com/LuaLS/lua-language-server) |
| HTML | html-lsp | [npm](https://www.npmjs.com/package/vscode-langservers-extracted) |
| CSS | cssls | [npm](https://www.npmjs.com/package/vscode-langservers-extracted) |
| JSON | jsonls | [npm](https://www.npmjs.com/package/vscode-langservers-extracted) |

## 1.3 Formatters

| Language | Formatter | Reference |
|----------|-----------|-----------|
| Python | ruff_format | [GitHub](https://github.com/astral-sh/ruff) |
| JS/TS/JSON/HTML/CSS/MD/YAML | prettier | [prettier.io](https://prettier.io/) |
| Rust | rustfmt | [GitHub](https://github.com/rust-lang/rustfmt) |
| Go | gofmt, goimports | [Go Tools](https://pkg.go.dev/golang.org/x/tools) |
| C/C++ | clang-format | [LLVM](https://clang.llvm.org/docs/ClangFormat.html) |
| Nix | nixfmt | [GitHub](https://github.com/NixOS/nixfmt) |
| Lua | stylua | [GitHub](https://github.com/JohnnyMorganz/StyLua) |

## 1.4 Terminal Tools

| Tool | Description | Reference |
|------|-------------|-----------|
| **yazi** | Blazing fast terminal file manager | [GitHub](https://github.com/sxyazi/yazi) / [Docs](https://yazi-rs.github.io/) |
| **fzf** | Command-line fuzzy finder | [GitHub](https://github.com/junegunn/fzf) |
| **ripgrep (rg)** | Fast recursive grep | [GitHub](https://github.com/BurntSushi/ripgrep) |
| **eza** | Modern ls replacement with git integration | [GitHub](https://github.com/eza-community/eza) |
| **bat** | Cat clone with syntax highlighting | [GitHub](https://github.com/sharkdp/bat) |
| **jq** | JSON query and manipulation | [GitHub](https://github.com/jqlang/jq) |
| **yq** | YAML query tool | [GitHub](https://github.com/mikefarah/yq) |
| **zsh** | Z Shell | [zsh.org](https://www.zsh.org/) |
| **starship** | Cross-shell prompt | [GitHub](https://github.com/starship/starship) |
| **direnv** | Directory-based environment | [GitHub](https://github.com/direnv/direnv) |
| **ghostty** | GPU-accelerated terminal | [GitHub](https://github.com/ghostty-org/ghostty) |

## 1.5 System Tools (macOS)

| Tool | Description | Reference |
|------|-------------|-----------|
| **nix-darwin** | Nix-based macOS configuration | [GitHub](https://github.com/LnL7/nix-darwin) |
| **home-manager** | Nix-based user environment | [GitHub](https://github.com/nix-community/home-manager) |
| **aerospace** | Tiling window manager | [GitHub](https://github.com/nikitabobko/AeroSpace) |
| **spoofdpi** | DPI circumvention proxy | [GitHub](https://github.com/xvzc/SpoofDPI) |
| **sops-nix** | Secret management | [GitHub](https://github.com/Mic92/sops-nix) |

## 1.6 GUI Applications (Homebrew Casks)

| App | Description |
|-----|-------------|
| Ghostty | GPU-accelerated terminal |
| Zed | Modern code editor |
| Slack | Team communication |
| Discord | Voice/text chat |
| Obsidian | Note-taking (markdown) |
| Bruno | REST API client |
| OrbStack | Docker alternative for macOS |
| TablePlus | Database GUI client |
| DBngin | Database management |
| VLC | Media player |
| OpenVPN Connect | VPN client |
| Google Chrome | Web browser |

---

# 2. Neovim Workflow Guide

## 2.1 Starting Neovim

```bash
# Open Neovim
nvim

# Open a specific file
nvim filename.py

# Open a directory
nvim .
```

When Neovim starts, you'll see the **Alpha dashboard** with quick actions:
- Press `e` to create a new file
- Press `f` to find files
- Press `r` for recent files
- Press `g` to search text (grep)
- Press `c` to edit neovim configuration
- Press `q` to quit

## 2.2 Understanding Vim Modes

| Mode | How to Enter | Purpose |
|------|--------------|---------|
| **Normal** | `Esc` | Navigate and execute commands |
| **Insert** | `i`, `a`, `o` | Type/edit text |
| **Visual** | `v`, `V`, `Ctrl+v` | Select text |
| **Command** | `:` | Execute Ex commands |
| **Terminal** | `Ctrl+\` | Use terminal inside Neovim |

## 2.3 File Navigation

### Opening Files with Telescope

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files (fuzzy search) |
| `<leader>fr` | Recent files |
| `<leader>fg` | Live grep (search text in all files) |
| `<leader>fw` | Search word under cursor |
| `<leader>fb` | List open buffers |

**Inside Telescope picker:**
- `Ctrl+n` / `Ctrl+p` - Navigate up/down
- `Enter` - Open file
- `Ctrl+x` - Open in horizontal split
- `Ctrl+v` - Open in vertical split
- `Ctrl+t` - Open in new tab
- `Esc` - Close picker

### Using Neo-tree (File Explorer)

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle file explorer |

**Inside Neo-tree:**
| Key | Action |
|-----|--------|
| `Enter` or `o` | Open file/folder |
| `a` | Create new file |
| `A` | Create new directory |
| `d` | Delete file |
| `r` | Rename file |
| `y` | Copy file |
| `x` | Cut file |
| `p` | Paste file |
| `H` | Toggle hidden files |
| `.` | Set as root directory |
| `<BS>` (Backspace) | Go up one directory |
| `s` | Open in vertical split |
| `S` | Open in horizontal split |
| `P` | Toggle preview |
| `q` | Close explorer |
| `?` | Show help |

## 2.4 Buffer Management (Tabs)

Buffers are like tabs - each open file is a buffer.

| Key | Action |
|-----|--------|
| `Tab` | Next buffer |
| `Shift+Tab` | Previous buffer |
| `<leader>bd` | Close buffer (prompts to save) |
| `<leader>bo` | Close all other buffers |
| `<leader>bp` | Pin current buffer |
| `<leader>bh` | Close buffers to the left |
| `<leader>bl` | Close buffers to the right |
| `<leader>b1` | Go to buffer 1 |
| `<leader>b2` | Go to buffer 2 |
| `<leader>b3` | Go to buffer 3 |

## 2.5 Window Splits

| Key | Action |
|-----|--------|
| `Ctrl+w v` | Vertical split |
| `Ctrl+w s` | Horizontal split |
| `Ctrl+h` | Move to left window |
| `Ctrl+j` | Move to bottom window |
| `Ctrl+k` | Move to top window |
| `Ctrl+l` | Move to right window |
| `Ctrl+w q` | Close current window |
| `Ctrl+w o` | Close all other windows |
| `Ctrl+w =` | Make all windows equal size |
| `Ctrl+w >` | Increase width |
| `Ctrl+w <` | Decrease width |
| `Ctrl+w +` | Increase height |
| `Ctrl+w -` | Decrease height |

## 2.6 Editing Files

### Basic Editing

| Key | Action |
|-----|--------|
| `i` | Insert before cursor |
| `a` | Insert after cursor |
| `o` | Insert new line below |
| `O` | Insert new line above |
| `Esc` | Return to normal mode |

### Saving and Quitting

| Command | Action |
|---------|--------|
| `:w` | Save file |
| `:q` | Quit (fails if unsaved) |
| `:wq` or `:x` | Save and quit |
| `:q!` | Force quit without saving |
| `:wa` | Save all buffers |
| `:qa` | Quit all buffers |

### Undo/Redo

| Key | Action |
|-----|--------|
| `u` | Undo |
| `Ctrl+r` | Redo |

### Copy/Paste (Yank/Put)

| Key | Action |
|-----|--------|
| `yy` | Copy (yank) current line |
| `y{motion}` | Copy with motion (e.g., `yw` = word) |
| `p` | Paste after cursor |
| `P` | Paste before cursor |
| `dd` | Cut (delete) current line |
| `d{motion}` | Cut with motion |

### Visual Selection

| Key | Action |
|-----|--------|
| `v` | Start character-wise selection |
| `V` | Start line-wise selection |
| `Ctrl+v` | Start block selection |
| `y` | Copy selection |
| `d` | Delete selection |
| `>` | Indent selection |
| `<` | Unindent selection |

### Moving Lines

| Key | Action |
|-----|--------|
| `Alt+j` | Move line/selection down |
| `Alt+k` | Move line/selection up |

## 2.7 Search and Replace

### Searching

| Key | Action |
|-----|--------|
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` | Next match |
| `N` | Previous match |
| `*` | Search word under cursor forward |
| `#` | Search word under cursor backward |
| `Esc` | Clear search highlight |

### Replace

```vim
# Replace first occurrence on current line
:s/old/new/

# Replace all on current line
:s/old/new/g

# Replace all in file
:%s/old/new/g

# Replace with confirmation
:%s/old/new/gc
```

### Flash Navigation (Quick Jump)

| Key | Action |
|-----|--------|
| `s` | Flash jump - type 2 chars, then label |
| `S` | Flash Treesitter (select by syntax) |

## 2.8 Code Navigation (LSP)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Go to references |
| `gi` | Go to implementation |
| `gy` | Go to type definition |
| `K` | Hover documentation |
| `Ctrl+k` | Signature help |
| `[d` | Previous diagnostic (error) |
| `]d` | Next diagnostic (error) |
| `<leader>cd` | Show diagnostic popup |
| `<leader>ca` | Code actions (quick fixes) |
| `<leader>rn` | Rename symbol |
| `<leader>cf` | Format code |

## 2.9 Code Completion

Completion appears automatically as you type.

| Key | Action |
|-----|--------|
| `Ctrl+Space` | Trigger/toggle completion |
| `Ctrl+n` / `Down` | Next item |
| `Ctrl+p` / `Up` | Previous item |
| `Ctrl+y` or `Enter` | Accept completion |
| `Ctrl+e` | Close menu |
| `Tab` | Jump to next snippet placeholder |
| `Shift+Tab` | Jump to previous placeholder |

## 2.10 Floating Terminal

| Key | Action |
|-----|--------|
| `Ctrl+\` | Toggle floating terminal |
| `Esc` | Exit terminal mode (to normal) |
| `i` | Re-enter terminal mode |
| `Ctrl+c` | Cancel command (in terminal mode) |
| `Ctrl+h/j/k/l` | Navigate to other windows |

**Running commands:**
```bash
# In floating terminal
yazi           # Open file manager
git status     # Check git status
npm run dev    # Run development server
```

**Important:** When running `yazi` in terminal:
- Press `q` to quit yazi
- If keys don't work, press `i` to enter terminal mode first

## 2.11 Git Operations

### Gitsigns (Hunk Operations)

| Key | Action |
|-----|--------|
| `]c` | Next git hunk (change) |
| `[c` | Previous git hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hS` | Stage entire buffer |
| `<leader>hu` | Undo stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hR` | Reset entire buffer |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line |
| `<leader>hd` | Diff this file |
| `<leader>tb` | Toggle blame on current line |

### Telescope Git Pickers

| Key | Action |
|-----|--------|
| `<leader>gc` | Git commits |
| `<leader>gb` | Git branches |
| `<leader>gs` | Git status |
| `<leader>gS` | Git stash |

## 2.12 Diagnostics Panel (Trouble)

| Key | Action |
|-----|--------|
| `<leader>xx` | Toggle diagnostics panel |
| `<leader>xd` | Buffer diagnostics only |
| `<leader>xw` | Workspace diagnostics |
| `<leader>xq` | Quickfix list |
| `<leader>xl` | Location list |
| `<leader>xr` | LSP references |
| `<leader>xs` | Symbols outline |

**Inside Trouble panel:**
| Key | Action |
|-----|--------|
| `j/k` | Navigate |
| `Enter` | Jump to location |
| `o` | Jump and close |
| `p` | Preview |
| `q` | Close panel |

## 2.13 Comments

| Key | Action |
|-----|--------|
| `gcc` | Toggle comment on line |
| `gc{motion}` | Comment with motion |
| `gbc` | Toggle block comment |
| `gcO` | Add comment above |
| `gco` | Add comment below |
| `gcA` | Add comment at end of line |

**Visual mode:**
| Key | Action |
|-----|--------|
| `gc` | Comment selection (linewise) |
| `gb` | Comment selection (blockwise) |

## 2.14 Surround Text

| Key | Action |
|-----|--------|
| `ys{motion}{char}` | Add surround |
| `yss{char}` | Surround entire line |
| `ds{char}` | Delete surround |
| `cs{old}{new}` | Change surround |

**Examples:**
- `ysiw"` - Surround word with `"`
- `yss)` - Surround line with `()`
- `ds"` - Delete surrounding `"`
- `cs"'` - Change `"` to `'`

## 2.15 Which-Key Help

Press `<leader>` (Space) and wait 300ms to see all available keybindings organized by category.

---

# 3. Terminal Tools Workflow

## 3.1 Yazi (File Manager)

### Starting Yazi

```bash
# Open in current directory
yazi

# Open in specific directory
yazi ~/projects
```

### Basic Navigation

| Key | Action |
|-----|--------|
| `h` | Go to parent directory |
| `j` | Move down |
| `k` | Move up |
| `l` or `Enter` | Open file/enter directory |
| `gg` | Go to first item |
| `G` | Go to last item |
| `/` | Search |
| `n` | Next search result |
| `N` | Previous search result |

### File Operations

| Key | Action |
|-----|--------|
| `a` | Create file |
| `A` | Create directory |
| `r` | Rename |
| `d` | Move to trash |
| `D` | Permanently delete |
| `y` | Copy (yank) |
| `x` | Cut |
| `p` | Paste |
| `Space` | Toggle selection |
| `v` | Visual mode (multi-select) |
| `V` | Select all |
| `Esc` | Clear selection |

### View Options

| Key | Action |
|-----|--------|
| `.` | Toggle hidden files |
| `z` | Jump to directory (fzf) |
| `Z` | Jump to directory (zoxide) |
| `~` | Go to home directory |
| `Tab` | Switch between panes |

### Exiting

| Key | Action |
|-----|--------|
| `q` | Quit yazi |

## 3.2 FZF (Fuzzy Finder)

### Shell Integration

```bash
# Search command history
Ctrl+r

# Search files
Ctrl+t

# Change directory
Alt+c
```

### Direct Usage

```bash
# Find and open file in neovim
nvim $(fzf)

# Find file with preview
fzf --preview 'bat --color=always {}'

# Search with ripgrep, select with fzf
rg --files | fzf
```

## 3.3 Ripgrep (Fast Search)

### Basic Usage

```bash
# Search for pattern in current directory
rg "pattern"

# Search in specific file type
rg "pattern" --type py

# Search with context (3 lines before/after)
rg -C 3 "pattern"

# Case-insensitive search
rg -i "pattern"

# Search for whole word
rg -w "word"

# Show only filenames
rg -l "pattern"

# Count matches
rg -c "pattern"
```

### Advanced Usage

```bash
# Search and replace (dry run)
rg "old" --replace "new"

# Exclude directories
rg "pattern" --glob '!node_modules/*'

# Search hidden files
rg "pattern" --hidden

# Search with regex
rg "func\w+\(" --type py
```

## 3.4 Eza (Better ls)

```bash
# List files (alias: ls)
eza

# Long format with details (alias: ll)
eza -l

# Show all including hidden (alias: la)
eza -la

# Tree view (alias: tree)
eza --tree

# With git status
eza -l --git

# Sort by modified time
eza -l --sort=modified
```

## 3.5 Bat (Better cat)

```bash
# View file with syntax highlighting
bat filename.py

# Show line numbers
bat -n filename.py

# Show non-printable characters
bat -A filename.py

# Plain output (no decorations)
bat -p filename.py
```

## 3.6 Common Workflows

### Find and Edit File

```bash
# Method 1: fzf + neovim
nvim $(fzf)

# Method 2: In neovim
# Press <leader>ff, type filename, Enter
```

### Search Text in Project

```bash
# Method 1: ripgrep in terminal
rg "search term"

# Method 2: In neovim
# Press <leader>fg, type search term
```

### Navigate and Open Files

```bash
# Method 1: yazi
yazi
# Navigate with h/j/k/l, press Enter to open

# Method 2: In neovim
# Press <leader>e to open Neo-tree
```

### Git Workflow

```bash
# In terminal
git status
git add .
git commit -m "message"
git push

# In neovim (with floating terminal)
# Ctrl+\ to open terminal
# Type git commands
# Ctrl+\ to close
```

---

# 4. Complete Keybindings Reference

## 4.1 Leader Key Groups

Your leader key is `Space`. All `<leader>` keymaps start with Space.

| Prefix | Category |
|--------|----------|
| `<leader>f` | Find/Telescope |
| `<leader>b` | Buffer |
| `<leader>c` | Code/LSP |
| `<leader>g` | Git |
| `<leader>h` | Git hunks |
| `<leader>s` | Search/Split |
| `<leader>t` | Toggle |
| `<leader>x` | Trouble/Diagnostics |

## 4.2 Quick Reference Card

### Essential Keys
```
Space           Leader key
Esc             Normal mode / Clear search
Ctrl+\          Toggle terminal
Tab/Shift+Tab   Next/Previous buffer
```

### File Operations
```
<leader>e       Toggle file explorer
<leader>ff      Find files
<leader>fg      Live grep
<leader>fr      Recent files
<leader>fb      Buffers
```

### Code
```
gd              Go to definition
K               Hover docs
<leader>ca      Code actions
<leader>rn      Rename
<leader>cf      Format
```

### Git
```
<leader>gs      Git status
<leader>gc      Git commits
]c / [c         Next/Previous hunk
<leader>hs      Stage hunk
```

### Windows
```
Ctrl+h/j/k/l    Navigate windows
Ctrl+w v        Vertical split
Ctrl+w s        Horizontal split
Ctrl+w q        Close window
```

### Editing
```
gcc             Toggle comment
ys{motion}"     Add surround
ds"             Delete surround
s               Flash jump
```

---

# Configuration Files

All configuration is in `/Users/maryln/.config/nix/`:

| File | Purpose |
|------|---------|
| `flake.nix` | Main Nix flake configuration |
| `modules/home/neovim.nix` | Neovim configuration |
| `modules/home/zsh.nix` | Zsh + yazi + fzf + bat + eza |
| `modules/home/git.nix` | Git configuration |
| `modules/home/starship.nix` | Shell prompt |
| `modules/home/ghostty.nix` | Terminal emulator |
| `modules/home/direnv.nix` | Directory environments |
| `modules/darwin/system.nix` | macOS system settings |
| `modules/darwin/aerospace.nix` | Window manager |

---

# Rebuilding Configuration

After making changes to any `.nix` file:

```bash
darwin-rebuild switch --flake ~/.config/nix#manson
```

Replace `manson` with your hostname if different.

---

# 5. Nix Internals & Development Workflows

## 5.1 How the Nix Store Works

### Content-Addressed Storage

The Nix store (`/nix/store/`) uses **content-addressed storage**. Each package's path is derived from:
- Its build inputs (source code, dependencies)
- Build instructions (derivation)
- All configuration options

```
/nix/store/<hash>-<name>-<version>/
           ▲
           └── SHA256 of all inputs = unique, reproducible path
```

### Store Deduplication

**Key insight:** If two projects use the same package with the same inputs, they share the SAME store path.

```
┌─────────────────────────────────────────────────────────────────┐
│                    NIX STORE DEDUPLICATION                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   Project A (Python)          Project B (Python)                │
│   ┌──────────────┐            ┌──────────────┐                  │
│   │ flake.nix    │            │ flake.nix    │                  │
│   │ python313    │            │ python313    │                  │
│   │ uv           │            │ uv           │                  │
│   └──────┬───────┘            └──────┬───────┘                  │
│          │                           │                          │
│          │    SAME STORE PATH!       │                          │
│          └──────────┬────────────────┘                          │
│                     ▼                                           │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │              /nix/store/                                │   │
│   │                                                         │   │
│   │  abc123...-python-3.13.11/  ◄── Referenced by BOTH      │   │
│   │  def456...-uv-0.9.21/       ◄── Referenced by BOTH      │   │
│   │  ghi789...-glibc-2.39/      ◄── Shared dependency       │   │
│   │                                                         │   │
│   └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│   KEY: Same inputs = Same hash = Same path = NO DUPLICATION    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### When Store Paths Differ

Different store paths are created when:
- Different nixpkgs revision (different package version)
- Different build options/flags
- Different dependencies

```
Project A (nixpkgs Jan 2025)     Project B (nixpkgs June 2025)
python 3.13.11                   python 3.13.15
       │                                │
       ▼                                ▼
/nix/store/abc...-python/        /nix/store/xyz...-python/
(DIFFERENT PATHS - both exist)
```

## 5.2 Templates

### How `nix flake init -t` Works

```bash
nix flake init -t ~/.config/nix#python
```

This **copies** template files to your project directory (not symlinks):

```
~/.config/nix/templates/python/     ~/my-project/
├── flake.nix  ──────────────────►  ├── flake.nix  (copied)
└── .envrc     ──────────────────►  └── .envrc     (copied)
```

Each project gets its own independent `flake.nix` and `flake.lock`.

### Available Templates

| Template | Command | Includes |
|----------|---------|----------|
| Python | `nix flake init -t ~/.config/nix#python` | python313, uv |
| Node.js | `nix flake init -t ~/.config/nix#node` | nodejs, pnpm |
| Rust | `nix flake init -t ~/.config/nix#rust` | rustc, cargo, rust-analyzer |
| Bun | `nix flake init -t ~/.config/nix#bun` | bun runtime |

## 5.3 Typical Package Sizes

| Package | Approx Size | Notes |
|---------|-------------|-------|
| **Python 3.13** | ~70-100 MB | Core interpreter |
| **uv** | ~15-25 MB | Fast Python package manager |
| **Bun** | ~50-80 MB | Runtime + bundler |
| **Node.js** | ~60-90 MB | Just the runtime |
| **Rust toolchain** | ~400-600 MB | Compiler is large |
| **Go** | ~150-200 MB | Compiler + stdlib |
| **GCC/Clang** | ~500 MB+ | C/C++ toolchain |
| **stdenv + glibc** | ~200-300 MB | Shared by everything |

**Note:** `stdenv` and `glibc` are shared across ALL projects - you only pay once!

## 5.4 Cleanup & Maintenance

### What Nix Cleans vs What It Doesn't

```
┌─────────────────────────────────────────────────────────────────┐
│                      CLEANUP SCOPE                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   nix-collect-garbage CLEANS:      Does NOT clean:             │
│   ✓ /nix/store/* (unused)          ✗ node_modules/             │
│   ✓ Old generations                ✗ .venv/                    │
│   ✓ Unused derivations             ✗ target/ (Rust)            │
│                                    ✗ __pycache__/              │
│                                    ✗ .cache/, build/, dist/    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Nix Store Cleanup Commands

```bash
# Remove old generations and garbage collect
nix-collect-garbage -d

# Just garbage collect (keep generations)
nix-collect-garbage

# Deduplicate with hard links (saves 25-35% space)
nix store optimise

# See store size
du -sh /nix/store

# List all roots (what's keeping things alive)
nix-store --gc --print-roots
```

### Project Dependency Cleanup (kondo)

For cleaning `node_modules`, `.venv`, `target/`, etc:

```bash
# Install kondo temporarily
nix shell nixpkgs#kondo

# Preview what would be deleted
kondo ~/Developer

# Actually delete (interactive)
kondo ~/Developer

# Delete all without prompts
kondo ~/Developer --all
```

**kondo detects:** `node_modules/`, `target/`, `.venv/`, `build/`, `dist/`, `__pycache__/`, `.cache/`, `vendor/`

### direnv Cache Cleanup

```bash
# Clear direnv cache
direnv prune

# Clear specific project cache
rm -rf ~/project/.direnv
```

### Complete Cleanup Workflow

```bash
# 1. Clean old Nix generations
nix-collect-garbage -d

# 2. Optimize store (hard link deduplication)
nix store optimise

# 3. Clean eval cache
rm -rf ~/.cache/nix

# 4. Clean direnv caches
direnv prune

# 5. Clean project dependencies (optional)
nix shell nixpkgs#kondo -c kondo ~/Developer --all
```

## 5.5 Fetching Packages Outside Nixpkgs

### Using fetchFromGitHub

```nix
{ pkgs, ... }:

let
  my-tool = pkgs.stdenv.mkDerivation {
    pname = "my-tool";
    version = "1.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "username";
      repo = "repo-name";
      rev = "v1.0.0";  # tag, branch, or commit
      sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };

    # Build instructions...
    buildPhase = "make";
    installPhase = "make install PREFIX=$out";
  };
in { }
```

### Getting the SHA256 Hash

```bash
# For GitHub repos (unpacks the tarball)
nix-prefetch-url --unpack https://github.com/user/repo/archive/v1.0.0.tar.gz

# For direct files
nix-prefetch-url https://example.com/file.tar.gz

# Or use placeholder and let Nix tell you the correct hash
sha256 = "";  # Nix will error with correct hash
```

### Nixpkgs vs Manual Fetch

| Aspect | Nixpkgs (`pkgs.python3`) | Manual Fetch |
|--------|--------------------------|--------------|
| **Binary cache** | ✓ Pre-built from cache.nixos.org | ✗ Build from source |
| **Patches** | ✓ Already patched for Nix | ✗ May need patches |
| **Dependencies** | ✓ Auto-resolved | ✗ You handle them |
| **Testing** | ✓ Tested by Hydra CI | ✗ Not tested |
| **Version** | ✗ Fixed to nixpkgs rev | ✓ Any version |
| **Speed** | ✓ Fast (download only) | ✗ Slow (compile) |

## 5.6 Nix Commands Explained

### Overview Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    NIX COMMAND LIFECYCLE                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   YOU RUN: nix develop / nix shell / nix run / nix build       │
│                              │                                  │
│                              ▼                                  │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │              1. EVALUATION                              │   │
│   │  • Parse flake.nix                                     │   │
│   │  • Compute derivation hashes                           │   │
│   │  • Lock dependencies (flake.lock)                      │   │
│   └─────────────────────────┬───────────────────────────────┘   │
│                             ▼                                   │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │              2. REALIZATION                             │   │
│   │  • Check if /nix/store paths exist                     │   │
│   │  • Download from cache OR build locally                │   │
│   └─────────────────────────┬───────────────────────────────┘   │
│                             ▼                                   │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │              3. ENVIRONMENT SETUP                       │   │
│   │  • Modify $PATH, env vars                              │   │
│   │  • NO background processes                             │   │
│   └─────────────────────────┬───────────────────────────────┘   │
│                             ▼                                   │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │              4. EXECUTION                               │   │
│   │  • shell → interactive shell                           │   │
│   │  • develop → bash with build env                       │   │
│   │  • run → execute and exit                              │   │
│   │  • build → create ./result symlink                     │   │
│   └─────────────────────────────────────────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Command Comparison

| Command | Purpose | What Happens | When to Use |
|---------|---------|--------------|-------------|
| `nix shell` | Add packages to PATH | Starts your shell with packages available | Quick tool access |
| `nix develop` | Full dev environment | Build environment with CC, CFLAGS, etc. | Building/compiling |
| `nix run` | Execute and exit | Runs program, then exits | One-shot commands |
| `nix build` | Build package | Creates `./result` symlink | Create artifacts |

### nix shell

**Purpose:** Temporarily add packages to your PATH.

```bash
# Run cowsay without installing it
nix shell nixpkgs#cowsay
cowsay "Hello!"
exit  # Shell exits, cowsay gone from PATH

# Multiple packages
nix shell nixpkgs#nodejs nixpkgs#yarn

# Run command directly
nix shell nixpkgs#jq -c jq '.name' package.json
```

**Use cases:**
- Try a tool without installing
- Quick one-off tasks
- Testing different versions

### nix develop

**Purpose:** Enter a full development/build environment.

```bash
# Enter dev shell defined in flake.nix
nix develop

# From a specific flake
nix develop github:owner/repo

# Run command in dev environment
nix develop -c make build
```

**What it sets up:**
- `$PATH` with all dependencies
- `$CC`, `$CXX` for C/C++ compilation
- `$PKG_CONFIG_PATH` for libraries
- Build hooks and phases
- All `buildInputs` and `nativeBuildInputs`

**Use cases:**
- Compiling C/C++/Rust/Go projects
- Running make, cmake, cargo
- Any project that needs build tools

### nix run

**Purpose:** Execute a program and exit.

```bash
# Run hello program
nix run nixpkgs#hello

# Run with arguments
nix run nixpkgs#ripgrep -- -i "pattern" .

# Run default app from flake
nix run .
```

**Use cases:**
- One-shot script execution
- CI/CD pipelines
- Quick tool usage

### nix build

**Purpose:** Build a derivation, create `./result` symlink.

```bash
# Build current flake's default package
nix build

# Build specific package
nix build nixpkgs#hello

# Build and show output path
nix build --print-out-paths
```

**Use cases:**
- Create release artifacts
- Build packages for deployment
- CI/CD build steps

## 5.7 Development Workflows by Language

### Web Development (Node.js / Bun)

```bash
# Initialize project
mkdir my-web-app && cd my-web-app
nix flake init -t ~/.config/nix#node  # or #bun
direnv allow

# Packages available: node, npm/pnpm/bun
npm install  # Creates node_modules/ (not in nix store)
npm run dev
```

**What's in Nix store:** Node.js runtime, npm/pnpm
**What's NOT in Nix store:** node_modules/ (in project directory)

### Python Development

```bash
# Initialize project
mkdir my-python-app && cd my-python-app
nix flake init -t ~/.config/nix#python
direnv allow

# Create virtual environment with uv
uv venv
source .venv/bin/activate
uv pip install flask

# Or use uv directly (no venv needed)
uv run python app.py
```

**What's in Nix store:** Python interpreter, uv
**What's NOT in Nix store:** .venv/ (in project directory)

### Rust Development

```bash
# Initialize project
mkdir my-rust-app && cd my-rust-app
nix flake init -t ~/.config/nix#rust
direnv allow

# Packages available: rustc, cargo, rust-analyzer
cargo init
cargo build
cargo run
```

**Recommended flake.nix for Rust:**
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { nixpkgs, rust-overlay, ... }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ rust-overlay.overlays.default ];
      };
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.rust-bin.stable.latest.default
          pkgs.rust-analyzer
        ];
      };
    };
}
```

**What's in Nix store:** rustc, cargo, stdlib
**What's NOT in Nix store:** target/ (build artifacts in project)

### Go Development

```bash
# Initialize project
mkdir my-go-app && cd my-go-app

# Create flake.nix
cat > flake.nix << 'EOF'
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { nixpkgs, ... }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = [ pkgs.go pkgs.gopls ];
      };
    };
}
EOF

echo "use flake" > .envrc
direnv allow

# Now go is available
go mod init myapp
go run .
```

**What's in Nix store:** Go compiler, gopls
**What's NOT in Nix store:** go.sum dependencies (in `~/go/pkg/mod/`)

### C/C++ Development

```bash
# Create project with C/C++ tools
mkdir my-c-app && cd my-c-app

cat > flake.nix << 'EOF'
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { nixpkgs, ... }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          gcc
          gnumake
          cmake
          pkg-config
          clang-tools  # clangd, clang-format
        ];
      };
    };
}
EOF

echo "use flake" > .envrc
direnv allow

# Compile
gcc -o main main.c
# or
make
# or
cmake -B build && cmake --build build
```

**Why use `nix develop` for C/C++:**
- Sets `$CC`, `$CXX`, `$CFLAGS`
- Configures `$PKG_CONFIG_PATH` for libraries
- Handles cross-compilation setup

## 5.8 direnv Integration

With direnv, environments load/unload automatically:

```
┌─────────────────────────────────────────────────────────────────┐
│                    DIRENV + NIX FLOW                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   $ cd ~/my-project                                             │
│         │                                                       │
│         ▼                                                       │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │  direnv detects .envrc                                  │   │
│   │  → Runs "use flake"                                     │   │
│   │  → Calls nix develop internally                         │   │
│   │  → Caches in .direnv/                                   │   │
│   │  → Modifies current shell                               │   │
│   │                                                         │   │
│   │  direnv: loading ~/my-project/.envrc                    │   │
│   │  direnv: using flake                                    │   │
│   │  Python 3.13.11 | uv 0.9.21                            │   │
│   └─────────────────────────────────────────────────────────┘   │
│         │                                                       │
│   $ cd ..                                                       │
│         │                                                       │
│         ▼                                                       │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │  direnv: unloading                                      │   │
│   │  → Restores original environment                        │   │
│   │  → No cleanup needed                                    │   │
│   └─────────────────────────────────────────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## 5.9 Quick Reference

### Common Commands

```bash
# Initialize project from template
nix flake init -t ~/.config/nix#python

# Allow direnv
direnv allow

# Update flake inputs
nix flake update

# Garbage collect
nix-collect-garbage -d

# Optimize store
nix store optimise

# Show flake info
nix flake show
nix flake metadata

# Enter dev shell manually (without direnv)
nix develop

# Run one-off command
nix shell nixpkgs#jq -c jq --help
```

### Environment Variables

Inside `nix develop`:

| Variable | Purpose |
|----------|---------|
| `$PATH` | Includes all package binaries |
| `$CC` | C compiler (gcc/clang) |
| `$CXX` | C++ compiler |
| `$PKG_CONFIG_PATH` | Library paths |
| `$NIX_CFLAGS_COMPILE` | Compiler flags |
| `$NIX_LDFLAGS` | Linker flags |

### Background Processes

**Important:** Nix commands do NOT create background processes.

- `nix shell` / `nix develop` → Just environment variables
- Exit shell → Environment gone immediately
- Store paths remain until garbage collected
- The `nix-daemon` runs separately (system service, always running)
