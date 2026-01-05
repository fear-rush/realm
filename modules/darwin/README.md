# Darwin Modules

## SpoofDPI Configuration

### How It Works

SpoofDPI is configured as a system-wide HTTP/HTTPS proxy with DPI bypass.
However, this causes issues with private network access (VPN, internal services).

**Workaround**: macOS proxy bypass is configured via `networksetup` to skip
private IP ranges. This is a "hacky" solution as it modifies macOS system
settings outside of declarative Nix control.

### Traffic Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              YOUR MAC                                       │
│                                                                             │
│  ┌─────────┐     ┌──────────────────┐     ┌─────────────────┐              │
│  │  Apps   │────▶│  macOS Proxy     │────▶│  Destination?   │              │
│  │ Chrome  │     │  Settings        │     │                 │              │
│  │ Slack   │     │                  │     └────────┬────────┘              │
│  │ Discord │     │ Bypass List:     │              │                       │
│  └─────────┘     │ - 10.0.0.0/8     │              │                       │
│                  │ - 172.16.0.0/12  │              ▼                       │
│                  │ - 192.168.0.0/16 │     ┌───────────────────┐            │
│                  └──────────────────┘     │  Private IP?      │            │
│                                           │  (10.x, 172.x,    │            │
│                                           │   192.168.x)      │            │
│                                           └─────────┬─────────┘            │
│                                                     │                      │
│                              ┌──────────────────────┴──────────────────┐   │
│                              │                                         │   │
│                              ▼                                         ▼   │
│                    ┌─────────────────┐                     ┌───────────────┐
│                    │  YES: DIRECT    │                     │  NO: PROXY    │
│                    │  (bypass proxy) │                     │  127.0.0.1:   │
│                    └────────┬────────┘                     │  8080         │
│                             │                              └───────┬───────┘
└─────────────────────────────┼──────────────────────────────────────┼───────┘
                              │                                      │
                              ▼                                      ▼
                    ┌─────────────────┐                     ┌─────────────────┐
                    │  VPN Gateway    │                     │  SpoofDPI       │
                    │  (OpenVPN)      │                     │  (DPI Bypass)   │
                    └────────┬────────┘                     └────────┬────────┘
                             │                                       │
                             ▼                                       ▼
                    ┌─────────────────┐                     ┌─────────────────┐
                    │  Private        │                     │  Public         │
                    │  Network        │                     │  Internet       │
                    │                 │                     │                 │
                    │  10.17.5.105    │                     │  google.com     │
                    │  Elasticsearch  │                     │  slack.com      │
                    └─────────────────┘                     └─────────────────┘
```

### VPN Role

The VPN (OpenVPN Connect) creates a tunnel to your remote private network.
When you connect to `10.17.5.105` (Elasticsearch), the traffic:

1. **Matches bypass rule** (10.0.0.0/8) → skips SpoofDPI proxy
2. **Routes through VPN gateway** → encrypted tunnel to remote network
3. **Reaches private server** → Elasticsearch responds directly

Without the bypass rule, traffic would go through SpoofDPI first, breaking
the connection because HTTP proxy forwards the full URL format.

### Current Bypass Ranges

- `*.local` - Local domains
- `169.254/16` - Link-local
- `127.0.0.1`, `localhost` - Loopback
- `10.0.0.0/8` - Private Class A (VPN, cloud internal)
- `172.16.0.0/12` - Private Class B
- `192.168.0.0/16` - Private Class C

### Inspect Current Settings

```bash
# Check if proxy is enabled
networksetup -getwebproxy Wi-Fi

# Check bypass domains
networksetup -getproxybypassdomains Wi-Fi

# Check all proxy settings
scutil --proxy
```

### Rollback to macOS Default

```bash
# Clear bypass domains
networksetup -setproxybypassdomains Wi-Fi ""

# Disable web proxy entirely
networksetup -setwebproxystate Wi-Fi off
networksetup -setsecurewebproxystate Wi-Fi off

# Or reset to system defaults (clears all proxy settings)
networksetup -setautoproxystate Wi-Fi off
```

### Known Limitations

1. **Not fully declarative**: macOS proxy bypass is set via activation script
2. **Network service specific**: Settings apply per-interface (Wi-Fi, Ethernet)
3. **May need re-apply**: Settings could be reset by macOS updates or network changes
