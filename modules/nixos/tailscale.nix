{ config, pkgs, ... }:

{
  # Tailscale VPN
  environment.systemPackages = [ pkgs.tailscale ];
  services.tailscale.enable = true;

  # Trust Tailscale interface - all services accessible via Tailscale
  # Allow Tailscale UDP port for direct connections
  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };
}
