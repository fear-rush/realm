{ config, pkgs, ... }:

{
  # OpenSSH server
  services.openssh = {
    enable = true;

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;

      AllowUsers = [ "server" ];

      Ciphers = [
        "chacha20-poly1305@openssh.com"
        "aes256-gcm@openssh.com"
        "aes128-gcm@openssh.com"
      ];

      KexAlgorithms = [
        "curve25519-sha256"
        "curve25519-sha256@libssh.org"
      ];

      Macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
      ];

      X11Forwarding = false;
      MaxAuthTries = 3;
      LoginGraceTime = 60;
    };

    ports = [ 22 ];
    openFirewall = true;
  };

  # Fail2ban for brute force protection
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "1h";
    bantime-increment = {
      enable = true;
      maxtime = "48h";
      factor = "4";
    };

    jails = {
      sshd = {
        settings = {
          enabled = true;
          port = "ssh";
          filter = "sshd";
          maxretry = 3;
        };
      };
    };
  };
}
