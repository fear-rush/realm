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

    # Trusted domains (Tailscale IP, hostname, and local network)
    settings.trusted_domains = [
      "100.127.173.76"
      "192.168.100.10"
      "cloud.cyprus-kelvin.ts.net"
    ];

    # Trusted proxies (allow Tailscale network)
    settings.trusted_proxies = [
      "100.64.0.0/10"
      "127.0.0.1"
    ];

    # Overwrite settings for Tailscale Serve reverse proxy
    settings.overwriteprotocol = "https";

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

  # Ensure admin password matches sops secret on every rebuild
  systemd.services.nextcloud-admin-password = {
    description = "Set Nextcloud admin password from sops";
    after = [ "nextcloud-setup.service" ];
    requires = [ "nextcloud-setup.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      OC_PASS="$(cat ${config.sops.secrets.nextcloud_admin_pass.path})"
      export OC_PASS
      ${config.services.nextcloud.occ}/bin/nextcloud-occ user:resetpassword --password-from-env admin
    '';
  };

  # Nginx - bind to localhost (for Caddy) and LAN (for direct access)
  services.nginx.virtualHosts."localhost" = {
    listen = [
      { addr = "127.0.0.1"; port = nextcloudPort; }
      { addr = "192.168.100.10"; port = nextcloudPort; }
    ];
  };

  # Open firewall for LAN access
  networking.firewall.allowedTCPPorts = [ nextcloudPort ];
}
