{ pkgs, inputs, ... }:

let
  spoofdpi = inputs.spoofdpi.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  # Add spoofdpi to system packages (for CLI access)
  environment.systemPackages = [ spoofdpi ];

  # Create launchd daemon for SpoofDPI
  launchd.daemons.spoofdpi = {
    serviceConfig = {
      Label = "com.spoofdpi.daemon";
      ProgramArguments = [
        "${spoofdpi}/bin/spoofdpi"
        "--listen-addr" "127.0.0.1:8080"
        "--dns-mode" "https"
        "--dns-https-url" "https://dns.cloudflare.com/dns-query"
        "--dns-qtype" "ipv4"
        "--dns-cache"
        "--system-proxy"
        "--log-level" "info"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/var/log/spoofdpi.log";
      StandardErrorPath = "/var/log/spoofdpi.error.log";
    };
  };

  # Configure macOS proxy bypass for private networks
  # This is a workaround since --system-proxy routes ALL traffic through SpoofDPI
  # See README.md for details on this "hacky" configuration
  system.activationScripts.postActivation.text = ''
    for service in $(networksetup -listallnetworkservices | tail -n +2); do
      networksetup -setproxybypassdomains "$service" \
        "*.local" "169.254/16" "127.0.0.1" "localhost" \
        "10.0.0.0/8" "172.16.0.0/12" "192.168.0.0/16" 2>/dev/null || true
    done
  '';
}
