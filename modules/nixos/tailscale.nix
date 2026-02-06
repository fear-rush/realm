{ config, pkgs, ... }:

{
  # Tailscale VPN
  environment.systemPackages = [ pkgs.tailscale ];
  services.tailscale = {
    enable = true;
    # Allow Caddy to fetch TLS certificates from Tailscale
    permitCertUid = "caddy";
  };

  # Trust Tailscale interface - all services accessible via Tailscale
  # Allow Tailscale UDP port for direct connections
  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };
}
