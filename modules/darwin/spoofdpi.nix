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
}
