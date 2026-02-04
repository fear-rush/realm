{ config, pkgs, ... }:

{
  # Enable networking via WiFi
  networking = {
    networkmanager.enable = true;

    # Firewall
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22   # SSH
        80   # HTTP
        443  # HTTPS
        9000 # Portainer
        9443 # Portainer HTTPS
      ];
      allowedUDPPorts = [ ];
      logRefusedConnections = true;
    };
  };
}
