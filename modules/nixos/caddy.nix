{ config, pkgs, ... }:

{
  # Tailscale auth key for Caddy plugin (tsnet nodes)
  sops.secrets.tailscale_caddy_authkey = {
    restartUnits = [ "caddy.service" ];
  };

  services.caddy = {
    enable = true;

    # Caddy with Tailscale plugin for virtual hosts
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/tailscale/caddy-tailscale@v0.0.0-20250207163903-69a970c84556" ];
      hash = "sha256-OydhzUGG3SUNeGXAsB9nqXtnwvD36+2p3QzDtU4YyFg=";
    };

    # Load TS_AUTHKEY from sops secret
    environmentFile = config.sops.secrets.tailscale_caddy_authkey.path;

    # Global Tailscale configuration for tsnet nodes
    globalConfig = ''
      tailscale {
        ephemeral false
        state_dir /var/lib/caddy/tailscale
      }
    '';

    # Virtual hosts - each gets its own Tailscale node
    virtualHosts = {
      "https://cloud.cyprus-kelvin.ts.net" = {
        extraConfig = ''
          bind tailscale/cloud
          reverse_proxy localhost:8080 {
            header_up X-Forwarded-Proto https
          }
        '';
      };

      # Add more services:
      # "https://jellyfin.cyprus-kelvin.ts.net" = {
      #   extraConfig = ''
      #     bind tailscale/jellyfin
      #     reverse_proxy localhost:8096
      #   '';
      # };
    };
  };

  # Ensure state directory exists
  systemd.tmpfiles.rules = [
    "d /var/lib/caddy/tailscale 0750 caddy caddy -"
  ];
}
