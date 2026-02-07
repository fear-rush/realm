# Shisui - NixOS Headless Server

NixOS headless server running on a repurposed laptop (Intel i3-2310M, 8GB DDR3, 464GB HDD). Managed declaratively through the same Nix flake as the macOS workstation (manson).

---

## Network Architecture

```
 REMOTE (anywhere in the world)                        LOCAL NETWORK (192.168.100.0/24)
 ──────────────────────────────                        ────────────────────────────────

 ┌─────────────────────┐                               ┌─────────────────────┐
 │  Phone / Laptop     │                               │  Mac (manson)       │
 │                     │                               │  192.168.100.x      │
 │  Tailscale app      │                               │                     │
 │  Nextcloud app      │                               │  Tailscale app      │
 └────────┬────────────┘                               └────────┬────────────┘
          │                                                     │
          │  WireGuard tunnel                                   │  LAN + WireGuard tunnel
          │  (encrypted, peer-to-peer)                          │
          │                                                     │
          ▼                                                     ▼
 ┌─────────────────────────────────────────────────────────────────────────────────────┐
 │                              Tailscale Coordination                                │
 │                          (NAT traversal, key exchange)                              │
 └─────────────────────────────────────────┬───────────────────────────────────────────┘
                                           │
               ┌───────────────────────────┼───────────────────────────┐
               │                           │                           │
               ▼                           ▼                           ▼
 ┌──────────────────────────────────────────────────────────────────────────────────────┐
 │                                                                                     │
 │   SHISUI  (Intel i3-2310M / 8GB DDR3 / 464GB HDD)                                  │
 │   NixOS Headless Server                                                             │
 │                                                                                     │
 │   ┌─────────────────────────────────────────────────────────────────────────────┐    │
 │   │  NETWORK INTERFACES                                                        │    │
 │   │                                                                             │    │
 │   │   wlp2s0 (WiFi)              tailscale0 (VPN)                               │    │
 │   │   192.168.100.10              100.127.173.76                                │    │
 │   │   ┌─────────────────┐         ┌──────────────────────┐                      │    │
 │   │   │ Firewall: STRICT│         │ Firewall: TRUSTED    │                      │    │
 │   │   │ TCP 22   (SSH)  │         │ All ports open to    │                      │    │
 │   │   │ TCP 80   (HTTP) │         │ Tailscale nodes      │                      │    │
 │   │   │ TCP 443  (HTTPS)│         │                      │                      │    │
 │   │   │ UDP 41641 (TS)  │         │                      │                      │    │
 │   │   └────────┬────────┘         └──────────┬───────────┘                      │    │
 │   │            └──────────────┬──────────────┘                                  │    │
 │   └───────────────────────────┼─────────────────────────────────────────────────┘    │
 │                               │                                                     │
 │   ┌───────────────────────────┼─────────────────────────────────────────────────┐    │
 │   │  SERVICES                 │                                                 │    │
 │   │                           ▼                                                 │    │
 │   │   ┌──────────────────────────────────────────────────────────┐               │    │
 │   │   │  SSH (port 22)                                  ssh.nix │               │    │
 │   │   │                                                         │               │    │
 │   │   │   root ──── key-only (prohibit-password)                │               │    │
 │   │   │              └─ ed25519 (firas)                         │               │    │
 │   │   │                                                         │               │    │
 │   │   │   server ── key-only (2 authorized keys)                │               │    │
 │   │   │              ├─ ed25519 (firas)                         │               │    │
 │   │   │              └─ ed25519 (key #2)                        │               │    │
 │   │   │                                                         │               │    │
 │   │   │   Hardened: chacha20-poly1305, curve25519, 3 max tries  │               │    │
 │   │   └──────────────────────────────────────────────────────────┘               │    │
 │   │                                                                             │    │
 │   │   ┌──────────────────────────────────────────────────────────┐               │    │
 │   │   │  CADDY (reverse proxy)                         caddy.nix│               │    │
 │   │   │  With Tailscale plugin for virtual hosts                │               │    │
 │   │   │                                                         │               │    │
 │   │   │   cloud.cyprus-kelvin.ts.net ──► localhost:8080         │               │    │
 │   │   │   (tsnet node: 100.89.212.26)     (Nextcloud/nginx)     │               │    │
 │   │   │                                                         │               │    │
 │   │   │   Each virtual host = separate Tailscale node           │               │    │
 │   │   │   Auto TLS certificates from Let's Encrypt              │               │    │
 │   │   └──────────────────────────────────────────────────────────┘               │    │
 │   │                                                                             │    │
 │   │   ┌──────────────────────────────────────────────────────────┐               │    │
 │   │   │  NEXTCLOUD (port 8080)                      nextcloud.nix│               │    │
 │   │   │  Self-hosted Cloud Storage                              │               │    │
 │   │   │                                                         │               │    │
 │   │   │   ┌──────────────┐  ┌────────────┐  ┌───────────────┐  │               │    │
 │   │   │   │  nginx       │  │ PostgreSQL │  │ Redis         │  │               │    │
 │   │   │   │  (localhost) │  │ (database) │  │ (cache)       │  │               │    │
 │   │   │   └──────┬───────┘  └─────┬──────┘  └───────┬───────┘  │               │    │
 │   │   │          └────────────────┼──────────────────┘          │               │    │
 │   │   │                           │                             │               │    │
 │   │   │                    ┌──────┴──────┐                      │               │    │
 │   │   │                    │ /var/lib/   │                      │               │    │
 │   │   │                    │  nextcloud/ │                      │               │    │
 │   │   │                    │ (files,     │                      │               │    │
 │   │   │                    │  data)      │                      │               │    │
 │   │   │                    └─────────────┘                      │               │    │
 │   │   └──────────────────────────────────────────────────────────┘               │    │
 │   │                                                                             │    │
 │   │   ┌──────────────────────────────────────────────────────────┐               │    │
 │   │   │  TAILSCALE (UDP 41641)                      tailscale.nix│              │    │
 │   │   │  WireGuard mesh VPN                                     │               │    │
 │   │   │  tailscale0 interface ── trusted (no firewall)          │               │    │
 │   │   │  permitCertUid = "caddy" (for TLS cert fetching)        │               │    │
 │   │   └──────────────────────────────────────────────────────────┘               │    │
 │   │                                                                             │    │
 │   └─────────────────────────────────────────────────────────────────────────────┘    │
 │                                                                                     │
 └─────────────────────────────────────────────────────────────────────────────────────┘


 ACCESS MATRIX
 ─────────────

 ┌─────────────────┬──────────────┬───────────────────────────────────┬─────────────────┐
 │ Service         │ LAN Access   │ Tailscale Access                  │ Public Internet │
 ├─────────────────┼──────────────┼───────────────────────────────────┼─────────────────┤
 │ SSH (root)      │ :22 key-only │ :22 key-only                      │ BLOCKED         │
 │ SSH (server)    │ :22 key-only │ :22 key-only                      │ BLOCKED         │
 │ Nextcloud       │ BLOCKED      │ https://cloud.cyprus-kelvin.ts.net│ BLOCKED         │
 │ PostgreSQL      │ BLOCKED      │ internal only                     │ BLOCKED         │
 │ Redis           │ BLOCKED      │ internal only                     │ BLOCKED         │
 └─────────────────┴──────────────┴───────────────────────────────────┴─────────────────┘

 No services are exposed to the public internet.
 Remote access is exclusively through Tailscale's encrypted WireGuard tunnels.
 Nextcloud is accessed via Caddy reverse proxy with automatic HTTPS.
```

---

## Hardware Specifications

| Component | Specification |
|-----------|---------------|
| CPU | Intel Core i3-2310M @ 2.10GHz (2 cores / 4 threads, Sandy Bridge) |
| RAM | 8GB DDR3 |
| Disk | 464GB HDD (MBR partition table) |
| Boot Mode | BIOS/Legacy (no UEFI) |
| Network | WiFi via wlp2s0 (managed by NetworkManager) |
| Ethernet | enp3s0 (available, unused) |

---

## Disk Partition Layout

```
/dev/sda (464GB HDD, MBR)
├── /dev/sda1  ~456GB  ext4   /     (root filesystem)
└── /dev/sda2  ~8GB    swap         (matches RAM)
```

Partitions are referenced by UUID in `hardware-configuration.nix` for stability across reboots.

---

## Installation Steps (From Scratch)

### 1. Prepare Boot Media

Download the NixOS Minimal ISO from https://nixos.org/download and flash it to a USB drive using BalenaEtcher.

### 2. Boot Into BIOS

Power on the laptop and press **F12** (or F2/Esc depending on manufacturer) to open the boot menu. Select the USB drive. The laptop boots in BIOS/Legacy mode.

Verify boot mode on the live environment:

```bash
ls /sys/firmware/efi
# "No such file or directory" confirms BIOS/Legacy mode
```

### 3. Connect to WiFi

```bash
sudo systemctl start NetworkManager
nmcli device wifi connect "YOUR_SSID" password "YOUR_PASSWORD"
ping -c 3 google.com
```

### 4. Partition the Disk

Identify the disk:

```bash
lsblk
```

Wipe and create MBR partitions:

```bash
sudo parted /dev/sda -- mklabel msdos
sudo parted /dev/sda -- mkpart primary ext4 1MB -8GB
sudo parted /dev/sda -- mkpart primary linux-swap -8GB 100%
```

### 5. Format and Mount

```bash
sudo mkfs.ext4 -L nixos /dev/sda1
sudo mkswap -L swap /dev/sda2
sudo mount /dev/disk/by-label/nixos /mnt
sudo swapon /dev/sda2
```

### 6. Generate Hardware Configuration

```bash
sudo nixos-generate-config --root /mnt
```

This creates `/mnt/etc/nixos/hardware-configuration.nix` containing kernel modules, filesystem UUIDs, swap devices, and CPU platform specific to this machine. This file is essential and must be committed to the repository.

### 7. Clone the Configuration Repository

```bash
nix-shell -p git
sudo git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git /mnt/etc/nixos/config
```

Copy the generated hardware config into the repo:

```bash
sudo cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/config/hosts/shisui/
cd /mnt/etc/nixos/config
sudo git add hosts/shisui/hardware-configuration.nix
```

**Important**: Nix flakes only see files tracked by git. Any new file must be `git add`-ed before `nixos-rebuild` or `nixos-install` will recognize it.

### 8. Install

```bash
cd /mnt/etc/nixos/config
sudo nixos-install --flake .#shisui
```

Set the root password when prompted. Reboot and remove the USB drive:

```bash
sudo reboot
```

### 9. Post-Install Setup

Connect to WiFi (NetworkManager persists connections across reboots):

```bash
nmcli device wifi connect "YOUR_SSID" password "YOUR_PASSWORD"
```

Set a static IP through NetworkManager:

```bash
nmcli connection modify "YOUR_SSID" \
  ipv4.addresses 192.168.100.10/24 \
  ipv4.gateway 192.168.100.1 \
  ipv4.dns "1.1.1.1 8.8.8.8" \
  ipv4.method manual
nmcli connection down "YOUR_SSID" && nmcli connection up "YOUR_SSID"
```

Set a password for the `server` user:

```bash
passwd server
```

---

## SSH Access

Both `root` and `server` users use SSH key-only authentication. Password login is globally disabled.

From your Mac:

```bash
ssh server@192.168.100.10   # daily use
ssh root@192.168.100.10     # system administration
```

Add to `~/.ssh/config` on your Mac for convenience:

```
Host shisui
    HostName 192.168.100.10
    User server
    IdentityFile ~/.ssh/id_ed25519
```

Then connect with `ssh shisui`.

### SSH Hardening

- Password authentication disabled globally
- Root login restricted to key-only (`prohibit-password`)
- Only `server` and `root` users allowed (`AllowUsers`)
- Max 3 auth attempts, 60s login grace time
- X11 forwarding disabled
- Ciphers restricted to `chacha20-poly1305`, `aes256-gcm`, `aes128-gcm`
- Key exchange restricted to `curve25519-sha256`
- MACs restricted to `hmac-sha2-512-etm`, `hmac-sha2-256-etm`

---

## Configuration Management

The repository is the single source of truth. Changes flow through git:

```
[Mac: edit configs] --> [git push] --> [Server: git pull] --> [nixos-rebuild switch]
```

### Applying Changes

On the server:

```bash
cd /etc/nixos/config
git pull
sudo nixos-rebuild switch --flake .#shisui
```

### Rollback

Via command:

```bash
sudo nixos-rebuild switch --rollback
```

Or select a previous generation from the GRUB boot menu under "NixOS - All configurations". Up to 10 generations are kept.

### Garbage Collection

Runs automatically every week. Deletes generations older than 30 days. The nix store is deduplicated via hard links automatically.

Manual cleanup:

```bash
sudo nix-collect-garbage -d
sudo nix-store --optimise
```

---

## Project Structure

```
~/.config/nix/
├── flake.nix                              # Entrypoint - defines both hosts
├── flake.lock                             # Pinned dependency versions
├── secrets/
│   └── secrets.yaml                       # Encrypted secrets (sops/age)
├── .sops.yaml                             # SOPS encryption rules
│
├── hosts/
│   ├── manson.nix                         # macOS workstation (aarch64-darwin)
│   └── shisui/
│       ├── default.nix                    # NixOS server (x86_64-linux)
│       └── hardware-configuration.nix     # Generated - machine-specific hardware
│
├── modules/
│   ├── darwin/                            # macOS-only system modules
│   │   ├── default.nix                    # Imports all darwin modules
│   │   ├── system.nix                     # Dock, Finder, trackpad defaults
│   │   ├── homebrew.nix                   # Declarative Homebrew casks/brews
│   │   ├── nix.nix                        # Nix GC/optimise settings (manual)
│   │   ├── devtools.nix                   # System-wide dev tools for GUI apps
│   │   └── openscreen.nix                 # Custom app derivation
│   │
│   ├── nixos/                             # NixOS-only server modules
│   │   ├── default.nix                    # Imports all nixos modules + GC
│   │   ├── caddy.nix                      # Caddy reverse proxy with Tailscale plugin
│   │   ├── nextcloud.nix                  # Nextcloud cloud storage
│   │   ├── laptop.nix                     # Hardware: lid, power, thermal, sysctl
│   │   ├── networking.nix                 # NetworkManager, firewall
│   │   ├── ssh.nix                        # OpenSSH hardening
│   │   ├── tailscale.nix                  # Tailscale VPN mesh network
│   │   └── users.nix                      # Users, SSH keys, sudo
│   │
│   ├── home/                              # User environment (home-manager)
│   │   ├── default.nix                    # Imports all home modules
│   │   ├── zsh.nix                        # Shell, aliases, fzf, bat, eza
│   │   ├── git.nix                        # Git config, SSH signing, gh CLI
│   │   ├── starship.nix                   # Prompt
│   │   ├── neovim.nix                     # Full nixvim configuration
│   │   ├── ghostty.nix                    # Terminal emulator config
│   │   ├── direnv.nix                     # nix-direnv integration
│   │   └── fastfetch.nix                  # System info display
│   │
│   └── shared/
│       └── sops.nix                       # Secret management
│
├── templates/                             # Dev environment templates
│   ├── node/                              # nix flake init -t ~/.config/nix#node
│   ├── python/
│   ├── rust/
│   └── bun/
│
└── ascii/                                 # Neovim dashboard art
```

---

## Host Comparison

### manson (macOS Workstation)

| Attribute | Value |
|-----------|-------|
| Platform | `aarch64-darwin` (Apple Silicon) |
| Framework | nix-darwin |
| User | `maryln` |
| Shell | zsh (via home-manager) |
| Nix Channel | nixpkgs-unstable |
| Modules | darwin + home + shared |
| Extra Integrations | home-manager, nixvim, nix-homebrew, sops-nix |
| Purpose | Development workstation |

### shisui (NixOS Server)

| Attribute | Value |
|-----------|-------|
| Platform | `x86_64-linux` (Intel i3-2310M) |
| Framework | NixOS |
| Users | `root`, `server` |
| Shell | bash |
| Nix Channel | nixpkgs-unstable (shared) |
| Modules | nixos only |
| Extra Integrations | Nextcloud, Caddy, Tailscale |
| Purpose | Headless server (cloud storage, VPN node) |

### Shared Between Both Hosts

| Item | manson | shisui |
|------|--------|--------|
| Nix flakes enabled | yes | yes |
| nixpkgs-unstable | yes | yes |
| git | yes (home-manager) | yes (system) |
| ripgrep | yes (home-manager) | yes (system) |
| fd | yes (home-manager) | yes (system) |
| jq | yes (home-manager) | yes (system) |
| tree | yes (system) | yes (system) |
| unzip | yes (system) | yes (system) |
| curl | installed by default | yes (system) |
| wget | installed by default | yes (system) |

### manson Only

- home-manager (zsh, neovim/nixvim, starship, ghostty, direnv, fastfetch, git config)
- Homebrew casks (Chrome, Slack, Obsidian, OrbStack, Discord, VS Code, etc.)
- Nerd Fonts (Hack)
- sops-nix secret management
- macOS system defaults (Dock, Finder, trackpad)
- Touch ID for sudo
- Development tools (nodejs, python, bun, uv, pnpm)

### shisui Only

- Nextcloud cloud storage (via Caddy reverse proxy)
- Caddy with Tailscale plugin (virtual hosts, auto HTTPS)
- Tailscale VPN mesh network (access services from anywhere)
- OpenSSH server with hardened config
- Firewall (ports 22, 80, 443 + Tailscale UDP)
- NetworkManager with WiFi power save disabled
- Laptop-as-server optimizations (lid ignore, no sleep, no GUI, no Bluetooth, no sound)
- Console screen blanking (setterm + consoleblank kernel param)
- Thermal management (thermald)
- Kernel sysctl tuning (network buffers, VM dirty pages, swappiness)
- GRUB bootloader (BIOS/MBR)
- Automatic garbage collection (weekly, 30d retention)
- Automatic nix store deduplication

---

## Server Services

| Service | Status | Port/URL | Config |
|---------|--------|----------|--------|
| Nextcloud | Running | https://cloud.cyprus-kelvin.ts.net | `modules/nixos/nextcloud.nix` |
| Caddy | Running | 443 (via tsnet) | `modules/nixos/caddy.nix` |
| Tailscale | Running | 41641/UDP | `modules/nixos/tailscale.nix` |
| SSH | Running | 22 | `modules/nixos/ssh.nix` |
| NetworkManager | Running | - | `modules/nixos/networking.nix` |
| thermald | Running | - | `modules/nixos/laptop.nix` |
| console-blank | Oneshot | - | `modules/nixos/laptop.nix` |
| systemd-timesyncd | Running | - | Built-in |
| systemd-oomd | Running | - | Built-in |

---

## Firewall Rules

| Port | Protocol | Service | Source |
|------|----------|---------|--------|
| 22 | TCP | SSH | `networking.nix` |
| 80 | TCP | HTTP (reserved) | `networking.nix` |
| 443 | TCP | HTTPS (reserved) | `networking.nix` |
| 41641 | UDP | Tailscale | `tailscale.nix` |

The `tailscale0` interface is trusted — all ports are accessible to Tailscale nodes without additional firewall rules. All other incoming connections on physical interfaces are dropped and logged.

---

## Nextcloud (Cloud Storage)

Nextcloud is a self-hosted cloud storage solution, accessible via HTTPS through the Caddy reverse proxy with Tailscale.

### Architecture

```
                                 shisui (192.168.100.10)
                                 ┌─────────────────────────────────────────────┐
                                 │                                             │
Browser ─────────────────────────│  Caddy (with Tailscale plugin)              │
  https://cloud.cyprus-kelvin    │  ├── tsnet node "cloud" (100.89.212.26)     │
  .ts.net                        │  └── reverse_proxy → localhost:8080        │
                                 │                                             │
                                 │  nginx (localhost:8080)                     │
                                 │  ├── PHP-FPM (Nextcloud app)                │
                                 │  ├── PostgreSQL (database)                  │
                                 │  └── Redis (cache/sessions)                 │
                                 │                                             │
                                 │  Storage:                                   │
                                 │  └── /var/lib/nextcloud/ (files, data)      │
                                 │                                             │
                                 └─────────────────────────────────────────────┘
```

### Configuration

Defined in `modules/nixos/nextcloud.nix`:

```nix
services.nextcloud = {
  enable = true;
  package = pkgs.nextcloud32;
  hostName = "localhost";

  settings.trusted_domains = [
    "100.127.173.76"
    "192.168.100.10"
    "cloud.cyprus-kelvin.ts.net"
  ];

  settings.trusted_proxies = [ "100.64.0.0/10" "127.0.0.1" ];
  settings.overwriteprotocol = "https";

  home = "/var/lib/nextcloud";
  maxUploadSize = "10G";

  config = {
    adminuser = "admin";
    adminpassFile = config.sops.secrets.nextcloud_admin_pass.path;
    dbtype = "pgsql";
  };

  database.createLocally = true;
  configureRedis = true;
  autoUpdateApps.enable = true;
};
```

### Access

| Method | URL |
|--------|-----|
| Tailscale | `https://cloud.cyprus-kelvin.ts.net` |

**Important**: Nextcloud is only accessible via Tailscale. The MagicDNS hostname resolves through Tailscale's DNS (100.100.100.100). If using Chrome's "Secure DNS" with Cloudflare, you must set it to "With your current service provider" for `.ts.net` domains to resolve.

### Managing Nextcloud

```bash
# Check if Nextcloud services are running
systemctl status phpfpm-nextcloud nginx

# Restart Nextcloud
sudo systemctl restart phpfpm-nextcloud

# Run occ commands
sudo -u nextcloud nextcloud-occ <command>

# Add a new user
sudo -u nextcloud nextcloud-occ user:add --display-name="John Doe" username

# List users
sudo -u nextcloud nextcloud-occ user:list

# Check Nextcloud status
sudo -u nextcloud nextcloud-occ status
```

### Viewing Logs

```bash
# Nextcloud PHP logs
sudo journalctl -u phpfpm-nextcloud -f

# nginx logs
sudo journalctl -u nginx -f

# PostgreSQL logs
sudo journalctl -u postgresql -f

# Redis logs
sudo journalctl -u redis-nextcloud -f
```

### Backup Strategy

Nextcloud data lives in two places:

| Data | Location | What It Contains |
|------|----------|------------------|
| Files | `/var/lib/nextcloud/` | User files, app data |
| Database | Managed by PostgreSQL | Users, shares, metadata |

To back up files:

```bash
# Check total size
du -sh /var/lib/nextcloud

# Rsync to external drive or remote
rsync -avz /var/lib/nextcloud/ /path/to/backup/nextcloud/
```

To back up the database:

```bash
sudo -u postgres pg_dumpall > /path/to/backup/nextcloud-db.sql
```

---

## Caddy (Reverse Proxy with Tailscale)

Caddy serves as the reverse proxy with the Tailscale plugin, creating virtual Tailscale nodes for each service. This provides:

- **Automatic HTTPS** with Let's Encrypt certificates
- **Domain isolation** - each service gets its own `.ts.net` hostname
- **Cookie isolation** - separate domains prevent cookie conflicts between services

### Architecture

```
                    Tailscale Network
                    ┌─────────────────────────────────────────────────┐
                    │                                                 │
Browser ────────────│──► cloud.cyprus-kelvin.ts.net (100.89.212.26)   │
                    │    │                                            │
                    │    └──► Caddy (tsnet node "cloud")              │
                    │         └──► reverse_proxy localhost:8080       │
                    │              └──► nginx (Nextcloud)             │
                    │                                                 │
                    │    (Future services can be added similarly)     │
                    │    jellyfin.cyprus-kelvin.ts.net → :8096        │
                    │    grafana.cyprus-kelvin.ts.net → :3000         │
                    │                                                 │
                    └─────────────────────────────────────────────────┘
```

### Configuration

Defined in `modules/nixos/caddy.nix`:

```nix
services.caddy = {
  enable = true;

  package = pkgs.caddy.withPlugins {
    plugins = [ "github.com/tailscale/caddy-tailscale@v0.0.0-20250207163903-69a970c84556" ];
    hash = "sha256-OydhzUGG3SUNeGXAsB9nqXtnwvD36+2p3QzDtU4YyFg=";
  };

  environmentFile = config.sops.secrets.tailscale_caddy_authkey.path;

  globalConfig = ''
    tailscale {
      ephemeral false
      state_dir /var/lib/caddy/tailscale
    }
  '';

  virtualHosts = {
    "https://cloud.cyprus-kelvin.ts.net" = {
      extraConfig = ''
        bind tailscale/cloud
        reverse_proxy localhost:8080
      '';
    };
  };
};
```

### Adding New Services

To add a new service (e.g., Jellyfin):

```nix
virtualHosts = {
  "https://cloud.cyprus-kelvin.ts.net" = { ... };

  "https://jellyfin.cyprus-kelvin.ts.net" = {
    extraConfig = ''
      bind tailscale/jellyfin
      reverse_proxy localhost:8096
    '';
  };
};
```

Each new virtual host creates a separate Tailscale node that appears in your Tailnet dashboard.

### Managing Caddy

```bash
# Check Caddy status
systemctl status caddy

# View logs
sudo journalctl -u caddy -f

# Restart Caddy (needed after config changes)
sudo systemctl restart caddy

# Reload Caddy config (may not work with tsnet - use restart instead)
sudo systemctl reload caddy
```

### Secrets

The Tailscale auth key for Caddy is stored in sops:

```yaml
# secrets/secrets.yaml
tailscale_caddy_authkey: TS_AUTHKEY=tskey-auth-XXXXX-XXXXXXXXXXXXX
```

Generate a new auth key at [Tailscale Admin → Settings → Keys](https://login.tailscale.com/admin/settings/keys) with "Reusable" enabled.

---

## Tailscale (VPN Mesh Network)

Tailscale creates a WireGuard-based mesh VPN that allows all enrolled devices to reach each other securely, regardless of network location.

### Architecture

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Mac (manson) │     │  Phone       │     │  Other device │
│  Tailscale    │     │  Tailscale   │     │  Tailscale    │
└──────┬───────┘     └──────┬───────┘     └──────┬───────┘
       │                    │                    │
       │    WireGuard encrypted tunnels          │
       │    (peer-to-peer when possible)         │
       │                    │                    │
       └────────────────────┼────────────────────┘
                            │
                     ┌──────┴───────┐
                     │  shisui      │
                     │  100.127.173.76
                     │              │
                     │  cloud (tsnet)
                     │  100.89.212.26
                     └──────────────┘
```

### Configuration

Defined in `modules/nixos/tailscale.nix`:

```nix
services.tailscale = {
  enable = true;
  permitCertUid = "caddy";  # Allow Caddy to fetch TLS certificates
};

networking.firewall = {
  trustedInterfaces = [ "tailscale0" ];
  allowedUDPPorts = [ config.services.tailscale.port ];
};
```

### Tailscale Nodes

| Node | IP | Purpose |
|------|-----|---------|
| shisui | 100.127.173.76 | Main server (system Tailscale) |
| cloud | 100.89.212.26 | Nextcloud (Caddy tsnet node) |

### Managing Tailscale

```bash
# Check connection status
tailscale status

# Show all connected nodes
tailscale status --peers

# Show this machine's Tailscale IPs
tailscale ip

# Disconnect from Tailnet
sudo tailscale down

# Reconnect
sudo tailscale up

# Check the systemd service
systemctl status tailscaled
```

### MagicDNS and Secure DNS

Tailscale uses MagicDNS (100.100.100.100) to resolve `.ts.net` hostnames. If your browser uses "Secure DNS" with a public resolver (like Cloudflare 1.1.1.1), `.ts.net` domains won't resolve because public DNS doesn't know about private Tailscale hostnames.

**Fix for Chrome:**
1. Go to `chrome://settings/security`
2. Under "Use secure DNS", select **"With your current service provider"**
3. This uses system DNS, which routes `.ts.net` to MagicDNS

---

## Display Power Saving

The laptop screen is blanked and powered down automatically since no display is needed for a headless server.

Configured in `modules/nixos/laptop.nix` using two mechanisms:

1. **Kernel parameter** (`consoleblank=60`) — tells the kernel to blank the console after 60 seconds of inactivity
2. **systemd oneshot service** (`console-blank`) — runs `setterm` at boot targeting `/dev/console` directly:
   - `--blank 1` — blank screen after 1 minute of inactivity
   - `--powerdown 2` — DPMS power down display after 2 minutes
   - `--powersave on` — enable display power saving mode

```bash
# Verify the console-blank service ran successfully
systemctl status console-blank

# Check current kernel consoleblank value (seconds, 0 = disabled)
cat /sys/module/kernel/parameters/consoleblank

# Manually blank the screen
sudo setterm --blank 1 --powerdown 2 --powersave on > /dev/console
```

---

## Kernel Tuning

Configured in `modules/nixos/laptop.nix` for server workload on 8GB RAM with HDD:

| Parameter | Value | Purpose |
|-----------|-------|---------|
| `vm.swappiness` | 10 | Minimize swap usage on HDD |
| `vm.dirty_ratio` | 60 | Allow large write cache before flush |
| `vm.dirty_background_ratio` | 2 | Start background writeback early |
| `net.core.somaxconn` | 65535 | Max socket listen backlog |
| `net.core.rmem_max` | 16MB | Max receive buffer |
| `net.core.wmem_max` | 16MB | Max send buffer |
| `net.ipv4.tcp_max_syn_backlog` | 65535 | Max pending TCP connections |

---

## NixOS as a Service Manager (Replacing Docker)

NixOS manages services natively through declarative Nix modules instead of Docker containers. Each service is defined in a `.nix` file, managed by systemd, and rebuilt atomically.

### Docker vs NixOS Comparison

| Docker | NixOS |
|--------|-------|
| `docker run nginx` | `services.nginx.enable = true;` |
| `docker ps` | `systemctl list-units --type=service --state=running` |
| `docker logs nginx` | `journalctl -u nginx` |
| `docker stop nginx` | `systemctl stop nginx` |
| `docker-compose up` | `nixos-rebuild switch --flake .#shisui` |
| `Dockerfile` | Nix module in `modules/nixos/` |
| `docker-compose.yaml` | `hosts/shisui/default.nix` imports |
| Container isolation | systemd sandboxing + firewall |

### Adding a New Service

1. Create a module file `modules/nixos/myservice.nix`
2. Import it in `modules/nixos/default.nix`
3. Push, pull, rebuild

Search available NixOS service options at https://search.nixos.org/options

---

## Service Management

### List Running Services

```bash
# All running services
systemctl list-units --type=service --state=running

# All enabled services (start on boot)
systemctl list-units --type=service --state=enabled

# All failed services
systemctl list-units --failed
```

### Control a Service

```bash
# Check status
systemctl status sshd

# Stop / Start / Restart
systemctl stop sshd
systemctl start sshd
systemctl restart sshd

# Reload config without restart (if supported)
systemctl reload sshd
```

---

## Logs and Debugging

All logs go through systemd's journal. No log files scattered across `/var/log/`.

### View Logs

```bash
# Follow all system logs
journalctl -f

# Logs for a specific service
journalctl -u sshd
journalctl -u caddy
journalctl -u phpfpm-nextcloud

# Follow a specific service (live tail)
journalctl -u caddy -f

# Logs since last boot
journalctl -b

# Only errors and above
journalctl -p err
```

---

## Troubleshooting

### Nextcloud not loading

Check if services are running:

```bash
systemctl status caddy phpfpm-nextcloud nginx postgresql redis-nextcloud
```

Check Caddy logs for TLS errors:

```bash
sudo journalctl -u caddy --since "5 minutes ago" | grep -i error
```

### DNS_PROBE_FINISHED_NXDOMAIN for .ts.net

Your browser is using a public DNS that doesn't know about Tailscale hostnames. Either:
- Disable "Secure DNS" in browser settings
- Or set it to "With your current service provider"

Verify DNS works via terminal:

```bash
dig cloud.cyprus-kelvin.ts.net
# Should return the Tailscale IP (e.g., 100.89.212.26)
```

### Caddy not starting

Check logs:

```bash
sudo journalctl -u caddy --since "5 minutes ago" --no-pager
```

Common issues:
- Invalid auth key: Check `sudo cat /run/secrets/tailscale_caddy_authkey`
- Port conflict: Another process using port 443
- tsnet state issue: Try `sudo rm -rf /var/lib/caddy/tailscale/*` and restart

### Tailscale not connecting

```bash
systemctl status tailscaled
sudo journalctl -u tailscaled -n 50

# Re-authenticate if needed
sudo tailscale up

# Verify the interface exists
ip addr show tailscale0
```

### Disk space running low

```bash
sudo nix-collect-garbage -d
sudo nix-store --optimise

# Check Nextcloud storage
du -sh /var/lib/nextcloud
```
