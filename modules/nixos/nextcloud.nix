{ config, pkgs, ... }:

let
  nextcloudDomain = "shisui.taild14c94.ts.net";
  certDir = "/var/lib/tailscale-cert";
in
{
  # Nextcloud admin password from sops (root-owned, nextcloud-setup runs as root)
  sops.secrets.nextcloud_admin_pass = { };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud32;
    hostName = nextcloudDomain;

    # Use HTTPS protocol for links
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

  # Tailscale HTTPS certificate provisioning
  systemd.services.tailscale-cert = {
    description = "Fetch Tailscale HTTPS certificate";
    after = [ "tailscaled.service" ];
    wants = [ "tailscaled.service" ];
    wantedBy = [ "multi-user.target" ];
    before = [ "nginx.service" ];
    requiredBy = [ "nginx.service" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    path = [ pkgs.tailscale ];

    script = ''
      mkdir -p ${certDir}
      tailscale cert \
        --cert-file=${certDir}/cert.pem \
        --key-file=${certDir}/key.pem \
        ${nextcloudDomain}
      chmod 640 ${certDir}/key.pem
      chown root:nginx ${certDir}/key.pem
    '';
  };

  # Renew certificate daily
  systemd.timers.tailscale-cert-renew = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  systemd.services.tailscale-cert-renew = {
    description = "Renew Tailscale HTTPS certificate";
    after = [ "tailscaled.service" ];
    wants = [ "tailscaled.service" ];

    serviceConfig = {
      Type = "oneshot";
    };

    path = [ pkgs.tailscale ];

    script = ''
      mkdir -p ${certDir}
      tailscale cert \
        --cert-file=${certDir}/cert.pem \
        --key-file=${certDir}/key.pem \
        ${nextcloudDomain}
      chmod 640 ${certDir}/key.pem
      chown root:nginx ${certDir}/key.pem
      systemctl reload nginx
    '';
  };

  # Nginx with Tailscale cert
  services.nginx.virtualHosts.${nextcloudDomain} = {
    forceSSL = true;
    sslCertificate = "${certDir}/cert.pem";
    sslCertificateKey = "${certDir}/key.pem";
  };
}
