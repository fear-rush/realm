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
 │  Immich app         │                               │  Tailscale app      │
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
 │   │   192.168.100.10              100.x.x.x                                     │    │
 │   │   ┌─────────────────┐         ┌──────────────────────┐                      │    │
 │   │   │ Firewall: STRICT│         │ Firewall: TRUSTED    │                      │    │
 │   │   │ TCP 22   (SSH)  │         │ All ports open to    │                      │    │
 │   │   │ TCP 80   (HTTP) │         │ Tailscale nodes      │                      │    │
 │   │   │ TCP 443  (HTTPS)│         │                      │                      │    │
 │   │   │ TCP 2283 (Immich│         │                      │                      │    │
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
 │   │   │  IMMICH (port 2283)                           immich.nix│               │    │
 │   │   │  Photo & Video Backup Server                            │               │    │
 │   │   │  Machine Learning: DISABLED                             │               │    │
 │   │   │                                                         │               │    │
 │   │   │   ┌──────────────┐  ┌────────────┐  ┌───────────────┐  │               │    │
 │   │   │   │  immich-api  │  │ PostgreSQL │  │ Redis         │  │               │    │
 │   │   │   │  (Node.js)   │  │ (metadata) │  │ (job queue)   │  │               │    │
 │   │   │   └──────┬───────┘  └─────┬──────┘  └───────┬───────┘  │               │    │
 │   │   │          └────────────────┼──────────────────┘          │               │    │
 │   │   │                           │                             │               │    │
 │   │   │                    ┌──────┴──────┐                      │               │    │
 │   │   │                    │ /var/lib/   │                      │               │    │
 │   │   │                    │   immich/   │                      │               │    │
 │   │   │                    │ (photos,    │                      │               │    │
 │   │   │                    │  videos,    │                      │               │    │
 │   │   │                    │  thumbs)    │                      │               │    │
 │   │   │                    └─────────────┘                      │               │    │
 │   │   └──────────────────────────────────────────────────────────┘               │    │
 │   │                                                                             │    │
 │   │   ┌──────────────────────────────────────────────────────────┐               │    │
 │   │   │  TAILSCALE (UDP 41641)                      tailscale.nix│              │    │
 │   │   │  WireGuard mesh VPN                                     │               │    │
 │   │   │  tailscale0 interface ── trusted (no firewall)          │               │    │
 │   │   └──────────────────────────────────────────────────────────┘               │    │
 │   │                                                                             │    │
 │   └─────────────────────────────────────────────────────────────────────────────┘    │
 │                                                                                     │
 └─────────────────────────────────────────────────────────────────────────────────────┘


 ACCESS MATRIX
 ─────────────

 ┌─────────────────┬──────────────┬──────────────────────┬────────────────────────────┐
 │ Service         │ LAN Access   │ Tailscale Access     │ Public Internet            │
 ├─────────────────┼──────────────┼──────────────────────┼────────────────────────────┤
 │ SSH (root)      │ :22 key-only │ :22 key-only         │ BLOCKED                    │
 │ SSH (server)    │ :22 key-only │ :22 key-only         │ BLOCKED                    │
 │ Immich          │ :2283        │ :2283                │ BLOCKED                    │
 │ PostgreSQL      │ BLOCKED      │ internal only        │ BLOCKED                    │
 │ Redis           │ BLOCKED      │ internal only        │ BLOCKED                    │
 └─────────────────┴──────────────┴──────────────────────┴────────────────────────────┘

 No services are exposed to the public internet.
 Remote access is exclusively through Tailscale's encrypted WireGuard tunnels.
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
│   │   ├── immich.nix                     # Immich photo/video backup server
│   │   ├── laptop.nix                     # Hardware: lid, power, thermal, sysctl, screen blank
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
│       └── sops.nix                       # Secret management (manson only, currently)
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
| Extra Integrations | Immich, Tailscale |
| Purpose | Headless server (photo backup, VPN node) |

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

- Immich photo/video backup server (port 2283, ML disabled)
- Tailscale VPN mesh network (access services from anywhere)
- OpenSSH server with hardened config
- Firewall (ports 22, 80, 443, 2283 + Tailscale UDP)
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

| Service | Status | Port | Config |
|---------|--------|------|--------|
| Immich | Running | 2283 | `modules/nixos/immich.nix` |
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
| 2283 | TCP | Immich | `immich.nix` (openFirewall) |
| 41641 | UDP | Tailscale | `tailscale.nix` |

The `tailscale0` interface is trusted — all ports are accessible to Tailscale nodes without additional firewall rules. All other incoming connections on physical interfaces are dropped and logged.

---

## Immich (Photo & Video Backup)

Immich is a self-hosted photo and video backup solution, configured as a storage-only server with machine learning disabled to conserve resources on the i3-2310M.

### Architecture

```
                                 shisui (192.168.100.10)
                                 ┌─────────────────────────────────┐
                                 │                                 │
Phone/Desktop App ──────────────>│  immich-server (systemd)        │
  (upload photos)    port 2283   │  ├── immich-api (Node.js)       │
                                 │  ├── PostgreSQL (database)      │
                                 │  └── Redis (cache/queue)        │
                                 │                                 │
                                 │  Storage:                       │
                                 │  └── /var/lib/immich/ (media)   │
                                 │                                 │
                                 └─────────────────────────────────┘
```

Immich runs as a systemd service (`immich-server.service`) which spawns the API server. PostgreSQL stores metadata (albums, users, timestamps, GPS data) and Redis handles job queues. All uploaded photos and videos are stored on disk at `/var/lib/immich/`.

Machine learning is disabled (`machine-learning.enable = false`), so features like facial recognition, smart search, duplicate detection, and OCR are unavailable. This significantly reduces RAM and CPU usage on the 8GB system.

### Configuration

Defined in `modules/nixos/immich.nix`:

```nix
services.immich = {
  enable = true;
  host = "0.0.0.0";         # Listen on all interfaces (not just localhost)
  port = 2283;
  openFirewall = true;       # Auto-open port 2283 in firewall
  machine-learning.enable = false;  # Disable ML for resource savings
};
```

Key options reference: https://mynixos.com/nixpkgs/options/services.immich

### Access

| Method | URL |
|--------|-----|
| LAN | `http://192.168.100.10:2283` |
| Tailscale | `http://<shisui-tailscale-ip>:2283` |

On first access, Immich presents a setup wizard to create the admin account. After setup, install the Immich mobile app (iOS/Android) and point it at the server URL to enable automatic photo backup.

### Systemd Units

Immich creates several systemd units:

| Unit | Purpose |
|------|---------|
| `immich-server.service` | Main Immich API server |
| `postgresql.service` | Database (auto-managed by Immich module) |
| `redis-immich.service` | Cache and job queue |

### Managing Immich

```bash
# Check if Immich is running
systemctl status immich-server

# Restart Immich (e.g., after config changes that weren't picked up)
sudo systemctl restart immich-server

# Stop Immich
sudo systemctl stop immich-server

# Start Immich
sudo systemctl start immich-server

# Check all Immich-related services
systemctl list-units 'immich*' 'redis-immich*' 'postgresql*'
```

### Viewing Logs

```bash
# Recent logs
sudo journalctl -u immich-server -n 100

# Follow logs in real-time (like docker logs -f)
sudo journalctl -u immich-server -f

# Logs since last boot
sudo journalctl -u immich-server -b

# Only errors
sudo journalctl -u immich-server -p err

# Database logs
sudo journalctl -u postgresql

# Redis logs
sudo journalctl -u redis-immich
```

### Debugging Immich

```bash
# 1. Check service status and recent output
systemctl status immich-server

# 2. Check if Immich is listening on the correct interface
sudo ss -tlnp | grep 2283
# Expected: 0.0.0.0:2283 (all interfaces)
# Problem:  [::1]:2283 (localhost only — restart needed)

# 3. Check for failed related services
systemctl list-units --failed | grep -E 'immich|postgres|redis'

# 4. View the generated systemd unit file
systemctl cat immich-server

# 5. Check disk space (photos fill up fast)
df -h /var/lib/immich
du -sh /var/lib/immich

# 6. Check memory usage (Immich + PostgreSQL can be heavy)
systemctl status immich-server | grep Memory
systemctl status postgresql | grep Memory
```

### Common Issues

**Immich not reachable from network:**
If `ss -tlnp | grep 2283` shows `[::1]:2283` instead of `0.0.0.0:2283`, the service is only listening on localhost. Restart it:

```bash
sudo systemctl restart immich-server
```

**Immich not restarting after rebuild:**
`nixos-rebuild switch` doesn't always restart services if the unit file didn't change. Force restart:

```bash
sudo systemctl restart immich-server
```

**Upload failures / slow uploads:**
Check available disk space and Immich logs:

```bash
df -h /var/lib/immich
sudo journalctl -u immich-server -p err --since "1 hour ago"
```

**Database issues:**
PostgreSQL is auto-managed. If it fails, check its logs:

```bash
sudo journalctl -u postgresql -n 50
sudo systemctl restart postgresql
sudo systemctl restart immich-server
```

### Backup Strategy

Immich data lives in two places:

| Data | Location | What It Contains |
|------|----------|------------------|
| Media files | `/var/lib/immich/` | Original photos, videos, thumbnails |
| Database | Managed by PostgreSQL | Users, albums, metadata, GPS, timestamps |

To back up media files:

```bash
# Check total size
du -sh /var/lib/immich

# Rsync to external drive or remote
rsync -avz /var/lib/immich/ /path/to/backup/immich/
```

To back up the database:

```bash
sudo -u postgres pg_dumpall > /path/to/backup/immich-db.sql
```

---

## Tailscale (VPN Mesh Network)

Tailscale creates a WireGuard-based mesh VPN that allows all enrolled devices to reach each other securely, regardless of network location. This means Immich (and all other services) are accessible from anywhere without exposing ports to the public internet.

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
                     │  Tailscale   │
                     │  ┌─────────┐ │
                     │  │ Immich  │ │
                     │  │ SSH     │ │
                     │  │ etc.    │ │
                     │  └─────────┘ │
                     └──────────────┘
```

### Configuration

Defined in `modules/nixos/tailscale.nix`:

```nix
environment.systemPackages = [ pkgs.tailscale ];
services.tailscale.enable = true;

networking.firewall = {
  trustedInterfaces = [ "tailscale0" ];       # All services accessible via Tailscale
  allowedUDPPorts = [ config.services.tailscale.port ];  # 41641 for direct connections
};
```

The `trustedInterfaces = [ "tailscale0" ]` setting means the firewall is fully open for traffic arriving through Tailscale. Any service running on shisui is automatically accessible to Tailscale nodes without needing per-port firewall rules.

### Initial Setup

After the first rebuild with Tailscale enabled:

```bash
# Authenticate the machine (prints a URL to open in browser)
sudo tailscale up

# Verify connection
tailscale status

# Show this machine's Tailscale IP
tailscale ip
```

Log into https://login.tailscale.com to manage devices, see IPs, and configure ACLs.

### Accessing Services via Tailscale

Once shisui is authenticated, use its Tailscale IP from any enrolled device:

```bash
# SSH via Tailscale (works from anywhere, not just LAN)
ssh server@<shisui-tailscale-ip>

# Immich via Tailscale
# Open in browser: http://<shisui-tailscale-ip>:2283
```

You can also use the Tailscale machine name (e.g., `shisui`) if MagicDNS is enabled in your Tailnet settings.

### Managing Tailscale

```bash
# Check connection status
tailscale status

# Show all connected nodes
tailscale status --peers

# Show this machine's Tailscale IPs
tailscale ip

# Disconnect from Tailnet (keeps config, just goes offline)
sudo tailscale down

# Reconnect
sudo tailscale up

# Check the systemd service
systemctl status tailscaled
```

### Debugging Tailscale

```bash
# Service status
systemctl status tailscaled

# Logs
sudo journalctl -u tailscaled -n 50
sudo journalctl -u tailscaled -f  # follow

# Check if Tailscale interface exists
ip addr show tailscale0

# Ping another Tailscale node
tailscale ping <other-node-name>

# Check firewall is trusting tailscale0
sudo iptables -L -n | grep tailscale
```

---

## Display Power Saving

The laptop screen is blanked and powered down automatically since no display is needed for a headless server.

Configured in `modules/nixos/laptop.nix` using two mechanisms:

1. **Kernel parameter** (`consoleblank=60`) — tells the kernel to blank the console after 60 seconds of inactivity
2. **systemd oneshot service** (`console-blank`) — runs `setterm` at boot targeting `/dev/console` directly:
   - `--blank 1` — blank screen after 1 minute of inactivity
   - `--powerdown 2` — DPMS power down display after 2 minutes
   - `--powersave on` — enable display power saving mode

Both mechanisms are needed because `consoleblank` alone is unreliable on some hardware. The `setterm` service writes escape sequences directly to `/dev/console` with `TERM=linux`, which works regardless of whether anyone is logged into the console.

```bash
# Verify the console-blank service ran successfully
systemctl status console-blank

# Check current kernel consoleblank value (seconds, 0 = disabled)
cat /sys/module/kernel/parameters/consoleblank

# Manually blank the screen (e.g., after a reboot where you used the console)
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

Example — enabling nginx:

```nix
# modules/nixos/nginx.nix
{ config, pkgs, ... }:
{
  services.nginx = {
    enable = true;
    virtualHosts."mysite" = {
      root = "/var/www/mysite";
    };
  };
}
```

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

### Inspect a Service Configuration

```bash
# View the generated systemd unit file
systemctl cat sshd

# View all properties
systemctl show sshd
```

---

## Logs and Debugging

All logs go through systemd's journal. No log files scattered across `/var/log/`.

### View Logs

```bash
# Follow all system logs (like docker logs -f)
journalctl -f

# Logs for a specific service
journalctl -u sshd
journalctl -u nginx
journalctl -u NetworkManager

# Follow a specific service (live tail)
journalctl -u sshd -f

# Logs since last boot
journalctl -b

# Logs since a specific time
journalctl --since "2026-02-04 20:00:00"
journalctl --since "1 hour ago"

# Only errors and above
journalctl -p err

# Kernel messages (like dmesg)
journalctl -k
```

### Disk Usage of Logs

```bash
# Check journal size
journalctl --disk-usage

# Trim logs older than 7 days
sudo journalctl --vacuum-time=7d

# Trim logs to max 500MB
sudo journalctl --vacuum-size=500M
```

### Debug a Failing Service

```bash
# 1. Check what failed
systemctl list-units --failed

# 2. Get the status and recent logs
systemctl status myservice

# 3. Get full logs
journalctl -u myservice --no-pager

# 4. Check the generated unit file for misconfigs
systemctl cat myservice

# 5. Analyze security/sandboxing of a service
systemd-analyze security myservice
```

---

## NixOS Rebuild Modes

```bash
# Apply changes and set as default boot entry
sudo nixos-rebuild switch --flake .#shisui

# Apply changes but DON'T set as default boot (safe testing - reverts on reboot)
sudo nixos-rebuild test --flake .#shisui

# Set as default boot but DON'T apply now (applies on next reboot)
sudo nixos-rebuild boot --flake .#shisui

# Dry run - show what would change without applying
sudo nixos-rebuild dry-activate --flake .#shisui

# Build only - check if config compiles without applying
sudo nixos-rebuild build --flake .#shisui
```

Use `test` when making risky changes (networking, SSH). If something breaks, reboot and the previous working config loads automatically.

---

## Inspect NixOS Configuration

```bash
# Query a specific option value
nixos-option services.openssh.enable

# Interactive REPL to explore the full config
nix repl '<nixpkgs/nixos>'
# Then: config.services.openssh.enable
# Then: config.networking.firewall.allowedTCPPorts

# List all available generations
ls -la /nix/var/nix/profiles/system-*-link

# Show current system generation
readlink /nix/var/nix/profiles/system
```

---

## Network Debugging

```bash
# Show all interfaces and IPs
ip addr

# Show current WiFi connection
nmcli connection show --active

# Show all saved WiFi profiles
nmcli connection show

# Show default gateway
ip route | grep default

# Show DNS servers
cat /etc/resolv.conf

# Test firewall - list all rules
sudo iptables -L -n

# Check what ports are listening
ss -tlnp

# Test connectivity to a specific port
nc -zv 192.168.100.10 22
```

---

## System Monitoring

```bash
# Real-time process monitor
htop
btop

# Disk usage
df -h

# Nix store size
du -sh /nix/store

# Memory usage
free -h

# Swap usage
swapon --show

# CPU info
lscpu

# System uptime
uptime

# Who is logged in
w

# Last logins
last
```

---

## Troubleshooting

### WiFi not connecting after rebuild

```bash
systemctl restart NetworkManager
ip link set wlp2s0 up
nmcli device wifi list
nmcli device wifi connect "SSID" password "PASSWORD"
```

### SSH connection refused

Check if SSH is running and listening:

```bash
systemctl status sshd
ss -tlnp | grep 22
```

### Lost SSH access after config change

Boot into a previous generation via GRUB menu ("NixOS - All configurations"), then fix the config and rebuild.

### Nix flake not seeing new files

New files must be staged in git before Nix can see them:

```bash
git add path/to/new/file.nix
```

### Immich not loading in browser

Check if the service is running and listening on the correct interface:

```bash
systemctl status immich-server
sudo ss -tlnp | grep 2283
```

If it shows `[::1]:2283`, it's only on localhost. Restart:

```bash
sudo systemctl restart immich-server
```

If the service isn't running at all, check logs:

```bash
sudo journalctl -u immich-server -n 50
sudo journalctl -u postgresql -n 50
sudo journalctl -u redis-immich -n 50
```

### Tailscale not connecting

```bash
# Check the daemon
systemctl status tailscaled
sudo journalctl -u tailscaled -n 50

# Re-authenticate if needed
sudo tailscale up

# Verify the interface exists
ip addr show tailscale0
```

### Services not accessible via Tailscale

Verify the `tailscale0` interface is trusted in the firewall:

```bash
sudo iptables -L -n | grep tailscale
tailscale ping <target-node>
```

### Disk space running low

```bash
sudo nix-collect-garbage -d
sudo nix-store --optimise

# Check Immich media storage specifically
du -sh /var/lib/immich
```
