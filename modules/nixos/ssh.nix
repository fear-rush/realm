{ config, pkgs, ... }:

{
  # OpenSSH server
  services.openssh = {
    enable = true;

    settings = {
      PermitRootLogin = "prohibit-password"; # Key-only for root
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;

      AllowUsers = [ "server" "root" ];

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
}
