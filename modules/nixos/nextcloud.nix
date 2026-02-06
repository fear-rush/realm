{ config, pkgs, ... }:

let
  nextcloudDomain = "shisui.taild14c94.ts.net";
in
{
  # Nextcloud admin password from sops (root-owned, nextcloud-setup runs as root)
  sops.secrets.nextcloud_admin_pass = { };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud31;
    hostName = nextcloudDomain;

    # Use HTTPS protocol for links (Tailscale handles encryption)
    settings.overwriteprotocol = "https";

    # Data storage
    home = "/var/lib/nextcloud";
    maxUploadSize = "10G";

    # Admin account - only used during initial setup
    config = {
      adminuser = "admin";
      adminpassFile = config.sops.secrets.nextcloud_admin_pass.path;

      # PostgreSQL database (recommended)
      dbtype = "pgsql";
    };

    # Auto-create PostgreSQL database
    database.createLocally = true;

    # Redis caching (recommended for performance)
    configureRedis = true;

    # Auto-update apps from appstore
    autoUpdateApps.enable = true;
  };

  # Nginx HTTPS with self-signed cert (Tailscale provides encryption)
  services.nginx.virtualHosts.${nextcloudDomain} = {
    forceSSL = true;
    sslCertificate = "/var/lib/nextcloud/ssl/cert.pem";
    sslCertificateKey = "/var/lib/nextcloud/ssl/key.pem";
  };

  # Create self-signed SSL certificate on activation
  system.activationScripts.nextcloudSSL = ''
    mkdir -p /var/lib/nextcloud/ssl
    if [ ! -f /var/lib/nextcloud/ssl/cert.pem ]; then
      ${pkgs.openssl}/bin/openssl req -x509 -nodes -days 3650 \
        -newkey rsa:2048 \
        -keyout /var/lib/nextcloud/ssl/key.pem \
        -out /var/lib/nextcloud/ssl/cert.pem \
        -subj "/CN=${nextcloudDomain}"
      chown -R nextcloud:nextcloud /var/lib/nextcloud/ssl
      chmod 600 /var/lib/nextcloud/ssl/key.pem
    fi
  '';
}
