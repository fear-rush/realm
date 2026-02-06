{ config, pkgs, ... }:

{
  # Tailscale auth key for Caddy plugin
  sops.secrets.tailscale_caddy_authkey = {
    restartUnits = [ "caddy.service" ];
  };

  services.caddy = {
    enable = true;

    # Caddy with Tailscale plugin
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/tailscale/caddy-tailscale@v0.0.0-20250207163903-69a970c84556" ];
      hash = "sha256-OydhzUGG3SUNeGXAsB9nqXtnwvD36+2p3QzDtU4YyFg=";
    };

    # Load TS_AUTHKEY from sops secret
    environmentFile = config.sops.secrets.tailscale_caddy_authkey.path;

    # Virtual hosts - each gets its own Tailscale node
    virtualHosts = {
      "https://cloud.cyprus-kelvin.ts.net" = {
        extraConfig = ''
          bind tailscale/cloud
          reverse_proxy localhost:8080
        '';
      };

      # Add more services here:
      # "https://jellyfin.cyprus-kelvin.ts.net" = {
      #   extraConfig = ''
      #     bind tailscale/jellyfin
      #     reverse_proxy localhost:8096
      #   '';
      # };
      #
      # "https://grafana.cyprus-kelvin.ts.net" = {
      #   extraConfig = ''
      #     bind tailscale/grafana
      #     tailscale_auth
      #     reverse_proxy localhost:3000 {
      #       header_up X-Webauth-User {http.auth.user.tailscale_user}
      #     }
      #   '';
      # };
    };
  };
}
