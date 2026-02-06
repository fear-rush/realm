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

  # Tailscale Serve - expose Nextcloud with HTTPS
  systemd.services.tailscale-serve = {
    description = "Configure Tailscale Serve for local services";
    after = [ "tailscaled.service" "network-online.target" ];
    wants = [ "tailscaled.service" "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "tailscale-serve-start" ''
        # Wait for tailscale to be ready
        sleep 5

        # Reset any existing serve config
        ${pkgs.tailscale}/bin/tailscale serve reset || true

        # Serve Nextcloud at root
        ${pkgs.tailscale}/bin/tailscale serve --bg --https=443 / http://localhost:8080
      '';
      ExecStop = "${pkgs.tailscale}/bin/tailscale serve reset";
    };
  };
}
