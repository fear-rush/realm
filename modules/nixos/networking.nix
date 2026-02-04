{ config, pkgs, lib, ... }:

{
  networking = {
    networkmanager.enable = true;

    # Disable wpa_supplicant (conflicts with NetworkManager)
    wireless.enable = lib.mkForce false;

    # DNS
    nameservers = [ "1.1.1.1" "8.8.8.8" ];

    # Firewall
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22  # SSH
        80  # HTTP
        443 # HTTPS
      ];
      allowedUDPPorts = [ ];
      logRefusedConnections = true;
    };
  };
}
