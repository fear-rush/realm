# Realm

I don't know why i'm using this nix and nix-darwin configuration. but, i'm excited to learn it more and maybe i will extend by adding more host later. Take this with a grain of salt. This worked on my nix-darwin setup, but your configuration may differ. 

My personal Nix configuration for macOS (nix-darwin) with home-manager integration, and secret management via SOPS.

## Structure

```
~/.config/nix/
├── flake.nix                 # Main entrypoint, all flake inputs
├── flake.lock                # Locked dependency versions
├── .sops.yaml                # SOPS encryption rules + age public keys
├── README.md
│
├── secrets/
│   └── secrets.yaml          # Encrypted secrets (safe to commit)
│
├── hosts/                    # Machine-specific configurations
│   └── manson.nix            # macOS machine "manson"
│
├── templates/                # Development environment templates
│   ├── node/flake.nix        # Node.js + pnpm
│   ├── python/flake.nix      # Python + uv
│   ├── rust/flake.nix        # Rust + rust-analyzer
│   └── bun/flake.nix         # Bun runtime
│
└── modules/
    ├── darwin/               # macOS-only system modules
    │   ├── default.nix       # Imports all darwin modules
    │   ├── system.nix        # System defaults (dock, finder, trackpad)
    │   ├── aerospace.nix     # Window manager configuration
    │   ├── homebrew.nix      # Homebrew casks
    │   ├── nix.nix           # Nix settings, GC, optimization
    │   └── spoofdpi.nix      # DPI bypass + encrypted DNS proxy
    │
    ├── shared/               # Cross-platform system modules
    │   └── sops.nix          # SOPS secret management
    │
    └── home/                 # Cross-platform home-manager modules
        ├── default.nix       # Imports all home modules + user packages
        ├── zsh.nix           # Shell configuration
        ├── git.nix           # Git + GitHub CLI + SSH signing
        ├── starship.nix      # Prompt configuration
        ├── neovim.nix        # Neovim (nixvim) configuration
        ├── ghostty.nix       # Terminal configuration
        └── direnv.nix        # nix-direnv for dev environments
```

## First-Time Setup

### 1. SSH Key

```bash
# Generate ed25519 key (if not exists)
ssh-keygen -t ed25519 -C "description"

# Add to GitHub: https://github.com/settings/keys
cat ~/.ssh/id_ed25519.pub
```

### 2. Age Key (SOPS)

```bash
# Create age key directory
mkdir -p ~/.config/sops/age

# Generate age key from SSH key
nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt

# Get public key (for .sops.yaml)
nix run nixpkgs#ssh-to-age -- -i ~/.ssh/id_ed25519.pub
# Output: age1ppms6tya82fggm97qt85xhjg2tzq9sgmxmp2r8s5gf9f0hhttajs2dlv52
```

### 3. Allowed Signers (SSH Commit Verification)

```bash
# Create allowed signers file for git
echo "description $(cat ~/.ssh/id_ed25519.pub)" > ~/.ssh/allowed_signers
```

## Commands

### Apply Configuration

```bash
# Rebuild and switch to new configuration
darwin-rebuild switch --flake ~/.config/nix#manson

# Build without switching (test)
darwin-rebuild build --flake ~/.config/nix#manson

# Show what would change
darwin-rebuild dry-run --flake ~/.config/nix#manson
```

### Update Dependencies

```bash
# Update all flake inputs
cd ~/.config/nix && nix flake update

# Update specific input
nix flake lock --update-input nixpkgs
nix flake lock --update-input home-manager
nix flake lock --update-input nixvim
nix flake lock --update-input sops-nix
```

### Garbage Collection

```bash
# Remove old generations
sudo nix-collect-garbage -d

# Remove generations older than 7 days
sudo nix-collect-garbage --delete-older-than 7d

# Optimize nix store
nix-store --optimise
```

## What's Installed

### System Packages (nix-darwin)

| Package | Description | Homepage |
|---------|-------------|----------|
| [gnused](https://www.gnu.org/software/sed/) | GNU sed, a batch stream editor | GPL-3.0+ |
| [gnutar](https://www.gnu.org/software/tar/) | GNU implementation of the `tar` archiver | GPL-3.0+ |
| [gawk](https://www.gnu.org/software/gawk/) | GNU implementation of Awk | GPL-3.0+ |
| [gnupg](https://gnupg.org) | GNU Privacy Guard, OpenPGP implementation | GPL-3.0+ |
| [p7zip](https://github.com/p7zip-project/p7zip) | 7-Zip file archiver with additional codecs | LGPL-2.1+ |
| zip, unzip, xz, zstd | Compression tools | Various |
| which, tree | Utilities | Various |
| [spoofdpi](https://github.com/xvzc/SpoofDPI) | DPI bypass proxy with encrypted DNS | MIT |

### User Packages (home-manager)

| Package | Description | Homepage |
|---------|-------------|----------|
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Fast grep alternative combining usability of ag with raw speed | Unlicense/MIT |
| [jq](https://jqlang.github.io/jq/) | Lightweight command-line JSON processor | MIT |
| [yq-go](https://mikefarah.gitbook.io/yq/) | Portable command-line YAML processor | MIT |
| [fzf](https://github.com/junegunn/fzf) | Command-line fuzzy finder written in Go | MIT |
| [eza](https://github.com/eza-community/eza) | Modern, maintained replacement for ls | EUPL-1.2 |
| [yazi](https://github.com/sxyazi/yazi) | Blazing fast terminal file manager in Rust | MIT |
| [lazyssh](https://github.com/Adembc/lazyssh) | TUI SSH connection manager | Apache-2.0 |

### Programs (home-manager)

| Program | Description | Homepage |
|---------|-------------|----------|
| zsh | Shell with autosuggestions, syntax-highlighting, fzf | - |
| [git](https://git-scm.com/) | Version control with SSH signing | GPL-2.0 |
| [gh](https://cli.github.com/) | GitHub CLI tool | MIT |
| [gh-dash](https://www.gh-dash.dev) | GitHub dashboard TUI for PRs and issues | MIT |
| [starship](https://starship.rs) | Minimal, fast, customizable prompt | ISC |
| [bat](https://github.com/sharkdp/bat) | Cat clone with syntax highlighting and Git integration | Apache-2.0/MIT |
| neovim | Editor via [nixvim](https://github.com/nix-community/nixvim) (see Neovim section below) | - |
| ghostty | Terminal emulator (config only, installed via homebrew) | - |

### Security

| Component | Description |
|-----------|-------------|
| [sops-nix](https://github.com/Mic92/sops-nix) | Encrypted secrets (age) → decrypted to `/run/secrets/` |
| [ssh-to-age](https://github.com/Mic92/ssh-to-age) | Convert SSH ed25519 keys to age keys |
| SSH signing | Commit verification without GPG |

### Homebrew Casks

| Cask | Description |
|------|-------------|
| google-chrome | Browser |
| obsidian | Note-taking |
| bruno | API client |
| orbstack | Docker/Linux VMs |
| slack | Communication |
| discord | Communication |
| ghostty | Terminal |
| openvpn-connect | VPN |
| dbngin | Database version manager |
| tableplus | Database GUI |
| vlc | Media player |
| claude-code | AI assistant |
| zed | Editor |
| keepassxc | Password manager |

## Neovim Configuration

Full Neovim configuration via [nixvim](https://github.com/nix-community/nixvim) with catppuccin theme.

### Plugins

| Plugin | Description |
|--------|-------------|
| **UI** | |
| [catppuccin](https://github.com/catppuccin/nvim) | Colorscheme |
| [lualine](https://github.com/nvim-lualine/lualine.nvim) | Statusline |
| [bufferline](https://github.com/akinsho/bufferline.nvim) | Buffer tabs |
| [indent-blankline](https://github.com/lukas-reineke/indent-blankline.nvim) | Indentation guides |
| [web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | File icons |
| [fidget](https://github.com/j-hui/fidget.nvim) | LSP progress indicator |
| [alpha-nvim](https://github.com/goolord/alpha-nvim) | Dashboard |
| [smear-cursor](https://github.com/sphamba/smear-cursor.nvim) | Cursor animation |
| **Navigation** | |
| [telescope](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder |
| [neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim) | File explorer |
| [flash](https://github.com/folke/flash.nvim) | Motion/search |
| **Editing** | |
| [treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting |
| [nvim-surround](https://github.com/kylechui/nvim-surround) | Surround text |
| [comment](https://github.com/numToStr/Comment.nvim) | Commenting |
| [treesj](https://github.com/Wansmer/treesj) | Split/join blocks |
| [vim-visual-multi](https://github.com/mg979/vim-visual-multi) | Multi-cursor (Ctrl+D like VS Code) |
| **Git** | |
| [gitsigns](https://github.com/lewis6991/gitsigns.nvim) | Git signs in gutter |
| **LSP & Completion** | |
| [blink-cmp](https://github.com/Saghen/blink.cmp) | Autocompletion |
| [conform-nvim](https://github.com/stevearc/conform.nvim) | Formatting |
| **Diagnostics** | |
| [trouble](https://github.com/folke/trouble.nvim) | Diagnostics panel |
| [todo-comments](https://github.com/folke/todo-comments.nvim) | Highlight TODO/FIXME |
| **Other** | |
| [toggleterm](https://github.com/akinsho/toggleterm.nvim) | Terminal |
| [which-key](https://github.com/folke/which-key.nvim) | Keybinding hints |

### LSP Servers (11)

| Server | Language |
|--------|----------|
| ts_ls | TypeScript/JavaScript |
| pyright | Python |
| ruff | Python linting |
| rust_analyzer | Rust (uses project toolchain via direnv) |
| clangd | C/C++ |
| gopls | Go |
| nil_ls | Nix |
| lua_ls | Lua |
| html | HTML |
| cssls | CSS |
| jsonls | JSON |

### Formatters (conform-nvim)

| Formatter | Languages |
|-----------|-----------|
| prettier | JS, TS, JSX, TSX, JSON, HTML, CSS, Markdown, YAML |
| ruff_format | Python |
| rustfmt | Rust |
| gofmt + goimports | Go |
| clang-format | C/C++ |
| nixfmt | Nix |
| stylua | Lua |

### Key Bindings

**Leader key:** `<Space>`

| Key | Action |
|-----|--------|
| **File/Find** | |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Find buffers |
| `<leader>fh` | Find help |
| `<leader>fr` | Recent files |
| `<leader>fd` | LSP definitions |
| `<leader>fi` | LSP implementations |
| `<leader>fy` | LSP type definitions |
| `<leader>e` | Toggle Neo-tree |
| **LSP (go to)** | |
| `gd` | Go to definition (Telescope) |
| `gD` | Go to declaration |
| `gr` | Go to references (Telescope) |
| `gi` | Go to implementation (Telescope) |
| `gy` | Go to type definition (Telescope) |
| `K` | Hover documentation |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename symbol |
| **Multi-cursor (vim-visual-multi)** | |
| `<C-n>` | Select word under cursor / next occurrence |
| `<C-Down>` | Add cursor below |
| `<C-Up>` | Add cursor above |
| `\\A` | Select all occurrences |
| `n/N` | Navigate to next/prev match |
| `q` | Skip current and go to next |
| **Diagnostics** | |
| `<leader>xx` | Toggle Trouble |
| `<leader>xw` | Workspace diagnostics |
| `<leader>xd` | Document diagnostics |
| `[d` / `]d` | Previous/next diagnostic |
| **Git** | |
| `<leader>gb` | Git blame line |
| `<leader>gd` | Git diff |
| `[c` / `]c` | Previous/next hunk |
| **Buffers** | |
| `<Tab>` | Next buffer |
| `<S-Tab>` | Previous buffer |
| `<leader>bd` | Delete buffer |
| **Search/Motion** | |
| `s` | Flash jump |
| `f/F/t/T` | Flash char motions |
| `/` | Search (flash enhanced) |
| **Terminal** | |
| `<leader>tt` | Toggle terminal |
| `<C-\>` | Toggle terminal (any mode) |
| **Formatting** | |
| `<leader>cf` | Format buffer |
| **Window Navigation** | |
| `<C-h/j/k/l>` | Move between windows |
| `<C-w>s` | Horizontal split |
| `<C-w>v` | Vertical split |
| `<C-w>q` | Close window |

## Secret Management (SOPS)

### How It Works

```
┌─────────────────────────────────────────────────────────────────┐
│  secrets/secrets.yaml (encrypted, safe to commit)               │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ context7_api_key: ENC[AES256_GCM,data:...,tag:...]      │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ darwin-rebuild switch
                              │ (decrypts using age key)
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  /run/secrets/ (tmpfs, RAM only, never touches disk)           │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ context7_api_key  →  "sk-actual-plaintext-key"          │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

**Key concepts:**
- **age encryption**: Modern, simple encryption tool (simpler than GPG)
- **ssh-to-age**: Your SSH key doubles as your encryption key
- **tmpfs**: Decrypted secrets live in RAM only, never written to disk
- **sops-nix**: NixOS/nix-darwin module that handles decryption at activation

### Adding New Secrets

```bash
# 1. Edit encrypted secrets file (opens in $EDITOR)
sops secrets/secrets.yaml

# 2. Add your secret (sops encrypts on save)
# anthropic_api_key: sk-ant-your-key-here

# 3. Define secret in modules/shared/sops.nix
sops.secrets.anthropic_api_key = {
  owner = "maryln";
  mode = "0400";
};

# 4. Rebuild to decrypt
darwin-rebuild switch --flake ~/.config/nix#manson

# 5. Access the decrypted secret
cat /run/secrets/anthropic_api_key
```

### Accessing Secrets in Applications

```bash
# Example: Add Context7 MCP to Claude Code with decrypted API key
claude mcp add context7 -- npx -y @upstash/context7-mcp@latest \
  --api-key "$(cat /run/secrets/context7_api_key)"

# Example: Export as environment variable
export ANTHROPIC_API_KEY=$(cat /run/secrets/anthropic_api_key)

# Example: Use in a script
#!/bin/bash
API_KEY=$(cat /run/secrets/my_api_key)
curl -H "Authorization: Bearer $API_KEY" https://api.example.com
```

### Team Workflow (Multi-User)

When working in a team, each member needs their own age key to decrypt secrets.

```
┌─────────────────────────────────────────────────────────────────┐
│  SOPS Team Access Model                                         │
│                                                                 │
│  .sops.yaml (public keys - safe to commit)                      │
│  ┌───────────────────────────────────────┐                      │
│  │ keys:                                 │                      │
│  │   - &muhammad age1abc...              │ ← Can decrypt        │
│  │   - &ali age1xyz...                   │ ← Can decrypt        │
│  │   - &server age1server...             │ ← Can decrypt        │
│  └───────────────────────────────────────┘                      │
│                                                                 │
│  secrets.yaml is encrypted with ALL public keys                 │
│  Anyone with a matching private key can decrypt                 │
└─────────────────────────────────────────────────────────────────┘
```

**Adding a new team member:**

```bash
# 1. NEW MEMBER: Generate SSH key and get age public key
ssh-keygen -t ed25519 -C "teammate@email.com"
ssh-to-age -i ~/.ssh/id_ed25519.pub
# Output: age1newmember... → Send this to an existing member

# 2. EXISTING MEMBER: Add their public key and re-encrypt
# Edit .sops.yaml to add: - &newmember age1newmember...
sops updatekeys secrets/secrets.yaml
git commit -am "Add newmember to SOPS" && git push

# 3. NEW MEMBER: Pull and set up age key
git pull
ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/Library/.../sops/age/keys.txt
sops secrets/secrets.yaml  # Now works!
```

**Adding a server:**

```bash
# Option A: Generate key on server
ssh-keygen -t ed25519  # On server
ssh-to-age -i ~/.ssh/id_ed25519.pub  # Get public key
# → Add to .sops.yaml, re-encrypt, deploy

# Option B: CI/CD (GitHub Actions)
age-keygen  # Generate locally
# → Add public key to .sops.yaml
# → Store private key as GitHub Secret: SOPS_AGE_KEY
# → In workflow: env: SOPS_AGE_KEY: ${{ secrets.SOPS_AGE_KEY }}
```

**Key rules:**
- Anyone can edit `.sops.yaml` (it only has public keys)
- Only existing authorized members can run `sops updatekeys`
- New members cannot decrypt until an existing member re-encrypts

## Git Configuration

### SSH Commit Signing

All commits are signed using your SSH key (modern alternative to GPG):

```bash
# Verify a signed commit
git log --show-signature

# Output shows:
# Good "git" signature for description with ED25519 key SHA256:...
```

**Configuration in `git.nix`:**
```nix
signing = {
  format = "ssh";
  key = "~/.ssh/id_ed25519.pub";
  signByDefault = true;
};
settings.gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
```

### GitHub CLI

```bash
# Check out a PR
gh pr checkout 123

# View PR details
gh pr view

# Open dashboard (gh-dash)
gh dash
```

### Git Aliases

| Alias | Command |
|-------|---------|
| `git st` | `git status` |
| `git co` | `git checkout` |
| `git br` | `git branch` |
| `git ci` | `git commit` |
| `git lg` | `git log --oneline --graph --decorate` |
| `git a` | `git add` |
| `git ca` | `git commit --amend` |
| `git can` | `git commit --amend --no-edit` |
| `git fa` | `git fetch --all` |

## macOS System Defaults

- Touch ID for sudo
- Dock: autohide, no recents, persistent apps
- Finder: show all files/extensions, list view, path bar
- Trackpad: tap to click, right click
- Keyboard: disable auto-correct, auto-capitalize, smart quotes

## Aerospace (Window Manager)

| Keybinding | Action |
|------------|--------|
| alt + h/j/k/l | Focus left/down/up/right |
| alt + shift + h/j/k/l | Move window |
| alt + 1-5 | Switch workspace 1-5 |
| alt + b/m/t/e | Switch workspace b/m/t/e |
| alt + shift + 1-5 | Move to workspace |
| alt + shift + f | Fullscreen |
| alt + tab | Toggle last workspace |
| alt + shift + ; | Service mode |

**Service mode (alt + shift + ;):**
| Key | Action |
|-----|--------|
| esc | Reload config |
| r | Flatten workspace tree |
| f | Toggle floating/tiling |
| backspace | Close all windows but current |

## SpoofDPI (Network Privacy)

SpoofDPI bypasses Deep Packet Inspection (DPI) used by ISPs to block websites.
It also provides encrypted DNS (DoH) to prevent DNS-based blocking.

### Features

| Feature | Description |
|---------|-------------|
| DPI Bypass | Spoofs TLS ClientHello to evade packet inspection |
| Encrypted DNS | DNS-over-HTTPS to Cloudflare (1.1.1.1) |
| System Proxy | Automatically configures macOS HTTP/HTTPS proxy |
| DNS Cache | Caches DNS responses for performance |

### Architecture

```
┌────────────────────────────────────────────────────────────────┐
│                         Your Mac                                │
│  ┌─────────────┐     ┌──────────────────┐     ┌─────────────┐  │
│  │   Browser   │────▶│     SpoofDPI     │────▶│  Internet   │  │
│  │   / Apps    │     │ (127.0.0.1:8080) │     │             │  │
│  └─────────────┘     └──────────────────┘     └─────────────┘  │
│                              │ DoH (HTTPS)                      │
│                              ▼                                  │
│                      ┌──────────────┐                           │
│                      │ Cloudflare   │                           │
│                      │ DNS (1.1.1.1)│                           │
│                      └──────────────┘                           │
└────────────────────────────────────────────────────────────────┘
```

### Troubleshooting

| Command | Description |
|---------|-------------|
| `sudo launchctl list \| grep spoofdpi` | Check service status |
| `cat /var/log/spoofdpi.log` | View logs |
| `cat /var/log/spoofdpi.error.log` | View error logs |
| `sudo launchctl stop com.spoofdpi.daemon` | Stop service |
| `sudo launchctl start com.spoofdpi.daemon` | Start service |

**Disable proxy (rollback):**
```bash
networksetup -setwebproxystate Wi-Fi off
networksetup -setsecurewebproxystate Wi-Fi off
```

## Adding a New Machine

### SSH Key Strategy

This configuration uses **per-machine SSH keys** (recommended):

```
┌─────────────────────────────────────────────────────────────────┐
│  Each machine has its own identity:                             │
│                                                                 │
│  Machine A                    Machine B                         │
│  ┌─────────────────────┐     ┌─────────────────────┐           │
│  │ ~/.ssh/id_ed25519   │     │ ~/.ssh/id_ed25519   │           │
│  │ (unique key)        │     │ (different key)     │           │
│  └─────────┬───────────┘     └─────────┬───────────┘           │
│            │                           │                        │
│            ▼                           ▼                        │
│  ┌─────────────────────┐     ┌─────────────────────┐           │
│  │ age key (via        │     │ age key (via        │           │
│  │ ssh-to-age)         │     │ ssh-to-age)         │           │
│  └─────────────────────┘     └─────────────────────┘           │
│                                                                 │
│  Both age public keys listed in .sops.yaml                      │
│  Both can decrypt secrets/secrets.yaml                          │
└─────────────────────────────────────────────────────────────────┘
```

**Why per-machine keys?**
- **Security**: Key compromise is isolated to one machine
- **Auditability**: GitHub shows which machine made each push
- **Best practice**: Follows SSH key management recommendations

**Your SSH key serves dual purposes:**
1. **GitHub authentication** + commit signing
2. **SOPS decryption** (via ssh-to-age → age key)

### Bootstrap (Fresh Machine)

On a brand new machine without SSH access to GitHub:

```bash
# 1. Clone via HTTPS (no SSH yet)
git clone https://github.com/YOUR_USERNAME/nix.git ~/.config/nix
cd ~/.config/nix

# 2. Generate SSH key
ssh-keygen -t ed25519 -C "your@email.com"

# 3. Add SSH public key to GitHub
cat ~/.ssh/id_ed25519.pub
# → Go to https://github.com/settings/keys and add it

# 4. Generate age key from SSH key
mkdir -p ~/.config/sops/age
nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/id_ed25519 \
  > ~/.config/sops/age/keys.txt

# 5. Get age public key (you'll need this)
nix run nixpkgs#ssh-to-age -- -i ~/.ssh/id_ed25519.pub
# Output: age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# 6. On EXISTING machine: Add new age public key to .sops.yaml and re-encrypt
#    (See step 2-3 below)

# 7. Pull the updated .sops.yaml
git pull

# 8. Switch remote to SSH (optional but recommended)
git remote set-url origin git@github.com:YOUR_USERNAME/nix.git

# 9. Create allowed signers file
echo "your@email.com $(cat ~/.ssh/id_ed25519.pub)" > ~/.ssh/allowed_signers

# 10. Build!
darwin-rebuild switch --flake ~/.config/nix#manson
```

### macOS (nix-darwin)

1. **Generate SSH + age keys on new machine:**
```bash
# SSH key
ssh-keygen -t ed25519 -C "your@email.com"

# Age key from SSH
mkdir -p ~/.config/sops/age
nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/id_ed25519 \
  > ~/.config/sops/age/keys.txt

# Get age public key
nix run nixpkgs#ssh-to-age -- -i ~/.ssh/id_ed25519.pub
```

2. **Add age public key to `.sops.yaml`:**
```yaml
keys:
  - &maryln age1ppms6tya82fggm97qt85xhjg2tzq9sgmxmp2r8s5gf9f0hhttajs2dlv52
  - &new_machine age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

creation_rules:
  - path_regex: secrets/secrets\.yaml$
    key_groups:
      - age:
          - *maryln
          - *new_machine
```

3. **Re-encrypt secrets with new key:**
```bash
sops updatekeys secrets/secrets.yaml
```

4. **Create host file `hosts/new-machine.nix`:**
```nix
{ inputs, pkgs, config, ... }:

{
  imports = [ ../modules/darwin ];

  environment.systemPackages = with pkgs; [
    # machine-specific packages
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.maryln = import ../modules/home;
  };

  nix.settings.experimental-features = "nix-command flakes";
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin"; # or x86_64-darwin
  system.primaryUser = "maryln";
}
```

5. **Add to `flake.nix`:**
```nix
"new-machine" = nix-darwin.lib.darwinSystem {
  system = "aarch64-darwin";
  specialArgs = { inherit inputs; };
  modules = [
    ./hosts/new-machine.nix
    sops-nix.darwinModules.sops
    home-manager.darwinModules.home-manager
    nix-homebrew.darwinModules.nix-homebrew
    { nix-homebrew = { enable = true; user = "maryln"; ... }; }
  ];
};
```

6. **Apply:** `darwin-rebuild switch --flake .#new-machine`

### NixOS

1. Create `hosts/nixos-machine.nix`
2. Add to `flake.nix`:
```nix
nixosConfigurations."nixos-machine" = nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { inherit inputs; };
  modules = [
    ./hosts/nixos-machine.nix
    sops-nix.nixosModules.sops
    home-manager.nixosModules.home-manager
  ];
};
```
3. Apply: `nixos-rebuild switch --flake .#nixos-machine`

### Non-NixOS Linux (standalone home-manager)

1. Create `hosts/linux-box.nix`:
```nix
{ inputs, pkgs, lib, ... }:

{
  imports = [ ../modules/home ];

  home.username = "maryln";
  home.homeDirectory = "/home/maryln";
}
```

2. Add to `flake.nix`:
```nix
homeConfigurations."maryln@linux-box" = home-manager.lib.homeManagerConfiguration {
  pkgs = nixpkgs.legacyPackages.x86_64-linux;
  extraSpecialArgs = { inherit inputs; };
  modules = [ ./hosts/linux-box.nix ];
};
```

3. Apply: `home-manager switch --flake .#maryln@linux-box`

## Adding New Modules

### Darwin Module

Create `modules/darwin/new-module.nix`:
```nix
{ pkgs, ... }:

{
  # darwin-specific configuration
}
```

Add to `modules/darwin/default.nix`:
```nix
imports = [
  ./system.nix
  ./aerospace.nix
  ./homebrew.nix
  ./new-module.nix  # add here
  ../shared/sops.nix
];
```

### Home Module

Create `modules/home/new-module.nix`:
```nix
{ pkgs, ... }:

{
  # home-manager configuration (cross-platform)
}
```

Add to `modules/home/default.nix`:
```nix
imports = [
  ./zsh.nix
  ./git.nix
  ./starship.nix
  ./neovim.nix
  ./ghostty.nix
  ./direnv.nix
  ./new-module.nix  # add here
];
```

## Developer Environments

Per-project development environments using **direnv + nix-direnv + flake devShells**.

### How It Works

```
┌─────────────────────────────────────────────────────────────────┐
│  cd ~/projects/my-app                                           │
│         │                                                       │
│         ▼                                                       │
│  .envrc: "use flake"                                            │
│         │                                                       │
│         ▼ direnv auto-activates                                 │
│  flake.nix devShell → Node.js 22, pnpm, etc.                    │
│         │                                                       │
│         ▼                                                       │
│  $ node --version → v22.21.1                                    │
│  $ which node → /nix/store/xxx-nodejs-22.21.1/bin/node          │
└─────────────────────────────────────────────────────────────────┘
```

### Start New Project

```bash
# Create Node.js project
mkdir my-app && cd my-app
nix flake init -t ~/.config/nix#node
direnv allow
# Done! node and pnpm are now available

# Other templates:
nix flake init -t ~/.config/nix#python  # Python + uv
nix flake init -t ~/.config/nix#rust    # Rust + rust-analyzer
nix flake init -t ~/.config/nix#bun     # Bun
```

### Add to Existing Project

```bash
cd existing-project

# Create flake.nix (copy from template or custom)
cp ~/.config/nix/templates/node/flake.nix .
echo "use flake" > .envrc

direnv allow
# Environment auto-activates on every cd
```

### Version Pinning

| Language | How to Pin |
|----------|------------|
| Node.js | `nodejs_20`, `nodejs_22`, `nodejs_24` or pin nixpkgs commit |
| Python | `python311`, `python312`, `python313` |
| Rust | rust-overlay: `rust-bin.stable."1.83.0".default` |
| Bun | Pin nixpkgs commit |

**Pin exact version via nixpkgs commit:**
```nix
# In project's flake.nix
inputs.nixpkgs.url = "github:NixOS/nixpkgs/5c2bc52fb9f8c264ed6c93bd20afa2ff5e763dce";
# Use nixhub.io to find commit for specific version
```

### Garbage Collection

Automatic GC runs weekly (Sunday 3am):
- Deletes generations older than 14 days
- Store optimization (deduplication) at 4am
- Dev shells are protected from GC via `keep-outputs` and `keep-derivations`

Manual cleanup:
```bash
# Remove old generations
sudo nix-collect-garbage -d

# Remove generations older than 7 days
sudo nix-collect-garbage --delete-older-than 7d

# Optimize store
nix-store --optimise
```

## MCP Servers (Claude Code)

Running MCP servers with Nix for Claude Code without global package installation.

### How It Works

```
┌─────────────────────────────────────────────────────────────────┐
│  Claude Code starts                                              │
│         │                                                       │
│         ▼                                                       │
│  Spawns MCP server as child process:                            │
│  "nix shell nixpkgs#nodejs -c npx -y @upstash/context7-mcp"     │
│         │                                                       │
│         ▼                                                       │
│  nix shell temporarily adds nodejs to $PATH                     │
│         │                                                       │
│         ▼                                                       │
│  -c runs: npx -y @upstash/context7-mcp --api-key "..."          │
│         │                                                       │
│         ▼                                                       │
│  MCP server runs in background, communicates via stdio          │
│  (stops when Claude Code exits)                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Command Breakdown

```bash
claude mcp add context7 -- nix shell nixpkgs#nodejs -c npx -y @upstash/context7-mcp --api-key "..."
```

| Part | What it does |
|------|--------------|
| `claude mcp add` | Claude Code CLI command to register an MCP server |
| `context7` | Name you give to this MCP server |
| `--` | Separator - everything after this is the actual command to run |
| `nix shell` | Temporarily provides packages without installing globally |
| `nixpkgs#nodejs` | Get `nodejs` package from the `nixpkgs` flake |
| `-c` | Execute a command instead of opening interactive shell |
| `npx -y ...` | The actual MCP server to run |

### Adding MCP Servers

**With API key from SOPS:**
```bash
# API key is read at add-time and stored in config
claude mcp add context7 -- nix shell nixpkgs#nodejs -c npx -y @upstash/context7-mcp --api-key "$(cat /run/secrets/context7_api_key)"
```

**From a flake (no dependencies needed):**
```bash
claude mcp add nixos -- nix run github:utensils/mcp-nixos
```

### Managing MCP Servers

```bash
# List all configured servers
claude mcp list

# Remove a server
claude mcp remove context7
claude mcp remove nixos

# Check server details
claude mcp get context7
```

### Garbage Collection

Removing an MCP server (`claude mcp remove`) only removes the configuration. Packages remain in `/nix/store/` until garbage collected:

```bash
# Check what's unused
nix-store --gc --print-dead

# Remove unused packages
sudo nix-collect-garbage -d
```

Your automatic GC (configured in `modules/darwin/nix.nix`) handles this weekly.

### MCP Scopes

| Scope | Location | Use Case |
|-------|----------|----------|
| `local` (default) | `.claude.json` in project | Personal, project-specific |
| `project` | `.mcp.json` in project root | Team-shared, version controlled |
| `user` | `~/.claude.json` | Available across all projects |

```bash
# Add with specific scope
claude mcp add myserver --scope user -- nix run github:some/mcp
```

## Background Services (launchd)

nix-darwin creates several launchd services to manage the system. These appear in macOS System Settings → General → Login Items → "Allow in the Background".

### View Running Services

```bash
sudo launchctl list | grep nix
```

### Service Reference

| Service | Source | Purpose |
|---------|--------|---------|
| `org.nixos.nix-daemon` | nix-darwin core | Main Nix daemon - handles all builds, downloads, and store operations. Always running. |
| `org.nixos.darwin-store` | nix-darwin core | Creates `/nix/store` APFS volume at boot. Required because macOS Catalina+ has read-only system volume. |
| `org.nixos.activate-system` | nix-darwin core | Applies configuration changes during `darwin-rebuild switch` (symlinks, services, etc). |
| `org.nixos.nix-gc` | `nix.nix` | Automatic garbage collection. Runs on schedule defined by `nix.gc.interval`. |
| `org.nixos.nix-optimise` | `nix.nix` | Store deduplication. Runs on schedule defined by `nix.optimise.interval`. |
| `org.nixos.sops-install-secrets` | `sops-nix` | Decrypts `secrets/secrets.yaml` → `/run/secrets/` during system activation. |
| `com.spoofdpi.daemon` | `spoofdpi.nix` | DPI bypass proxy with DoH. Always running with `KeepAlive`. |

### Why "sh" Processes Appear

macOS Login Items may show unnamed `sh` processes. These are normal - nix-darwin wraps scheduled jobs and services in shell scripts for environment setup.

### Configuration

**Garbage Collection** (`modules/darwin/nix.nix`):
```nix
nix.gc = {
  automatic = true;
  interval = { Weekday = 0; Hour = 3; Minute = 0; };  # Sunday 3 AM
  options = "--delete-older-than 14d";
};
```

**Store Optimization** (`modules/darwin/nix.nix`):
```nix
nix.optimise = {
  automatic = true;
  interval = { Weekday = 0; Hour = 4; Minute = 0; };  # Sunday 4 AM
};
```

**SOPS Secrets** (`modules/shared/sops.nix`):
- Secrets are decrypted using your age key during `darwin-rebuild switch`
- Decrypted files appear at `/run/secrets/<secret-name>`
- Files are stored in tmpfs (RAM only, never written to disk)

### Managing Services

```bash
# Check service status
sudo launchctl list | grep -E 'nix|spoofdpi|sops'

# Stop a service
sudo launchctl stop org.nixos.nix-gc

# Start a service
sudo launchctl start org.nixos.nix-gc

# View service definition
sudo launchctl print system/org.nixos.nix-daemon
```

## Flake Inputs

| Input | Description | URL |
|-------|-------------|-----|
| [nixpkgs](https://github.com/NixOS/nixpkgs) | Nix packages (unstable) | github:NixOS/nixpkgs/nixpkgs-unstable |
| [nix-darwin](https://github.com/nix-darwin/nix-darwin) | macOS system configuration | github:nix-darwin/nix-darwin |
| [home-manager](https://github.com/nix-community/home-manager) | User environment management | github:nix-community/home-manager |
| [nixvim](https://github.com/nix-community/nixvim) | Neovim configuration in Nix | github:nix-community/nixvim |
| [nix-homebrew](https://github.com/zhaofengli/nix-homebrew) | Declarative Homebrew management | github:zhaofengli/nix-homebrew |
| [sops-nix](https://github.com/Mic92/sops-nix) | Secret management with age encryption | github:Mic92/sops-nix |
| [spoofdpi](https://github.com/xvzc/SpoofDPI) | DPI bypass proxy with DoH | github:xvzc/SpoofDPI |

## Troubleshooting

### Rebuild fails

```bash
# Show full trace
darwin-rebuild switch --flake .#manson --show-trace

# Check flake validity
nix flake check
```

### SOPS can't decrypt secrets

```bash
# Check age key exists
ls -la ~/.config/sops/age/keys.txt

# Verify key content (should start with AGE-SECRET-KEY-)
head -c 20 ~/.config/sops/age/keys.txt

# Re-generate age key from SSH
nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/id_ed25519 \
  > ~/.config/sops/age/keys.txt

# Verify public key matches .sops.yaml
nix run nixpkgs#ssh-to-age -- -i ~/.ssh/id_ed25519.pub
```

### Permission denied on secrets

```bash
# Check secret ownership
ls -la /run/secrets/

# Verify owner in sops.nix matches your username
sops.secrets.my_secret = {
  owner = "maryln";  # Must match your username
  mode = "0400";
};
```

### Homebrew issues

```bash
# Reset homebrew state
brew bundle --file=/dev/null --cleanup --force

# Reinstall via nix
darwin-rebuild switch --flake .#manson
```

### Home-manager conflicts

```bash
# Remove conflicting files
rm -rf ~/.config/<conflicting-dir>

# Re-apply
darwin-rebuild switch --flake .#manson
```

### Reset to clean state

```bash
# Remove all generations
sudo nix-collect-garbage -d

# Rebuild
darwin-rebuild switch --flake .#manson
```

### Network/Proxy issues

**Check proxy settings:**
```bash
networksetup -getwebproxy Wi-Fi
networksetup -getsecurewebproxy Wi-Fi
networksetup -listallnetworkservices
```

**Manage SpoofDPI service:**
```bash
sudo launchctl list | grep spoofdpi
sudo launchctl stop com.spoofdpi.daemon
sudo launchctl start com.spoofdpi.daemon
```

**Disable proxy (emergency rollback):**
```bash
networksetup -setwebproxystate Wi-Fi off
networksetup -setsecurewebproxystate Wi-Fi off
```

**View SpoofDPI logs:**
```bash
cat /var/log/spoofdpi.log
cat /var/log/spoofdpi.error.log
```
