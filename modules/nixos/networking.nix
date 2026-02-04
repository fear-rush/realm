{ config, pkgs, ... }:

{
  networking = {
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };

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
