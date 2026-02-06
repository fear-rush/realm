{ config, pkgs, ... }:

let
  nextcloudPort = 8080;
in
{
  # Nextcloud admin password from sops
  sops.secrets.nextcloud_admin_pass = { };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud32;
    hostName = "localhost";

    # Trusted domains (Tailscale IP and local network)
    settings.trusted_domains = [
      "100.127.173.76"
      "192.168.100.10"
    ];

    # Data storage
    home = "/var/lib/nextcloud";
    maxUploadSize = "10G";

    # Admin account - only used during initial setup
    config = {
      adminuser = "admin";
      adminpassFile = config.sops.secrets.nextcloud_admin_pass.path;
      dbtype = "pgsql";
    };

    database.createLocally = true;
    configureRedis = true;
    autoUpdateApps.enable = true;
  };

  # Nginx - HTTP on custom port
  services.nginx.virtualHosts."localhost" = {
    listen = [
      { addr = "0.0.0.0"; port = nextcloudPort; }
    ];
  };

  # Open firewall for Nextcloud port
  networking.firewall.allowedTCPPorts = [ nextcloudPort ];
}
