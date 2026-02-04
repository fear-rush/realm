{ config, pkgs, ... }:

{
  # Enable networking via WiFi
  networking = {
    wireless = {
      enable = true;

      # Replace with your WiFi name and password
      networks = {
        "YourWiFiName" = {
          psk = "your-wifi-password";
        };
      };
    };

    # Static IP (recommended for servers)
    # Uncomment and adjust:
    # interfaces.wlp2s0.ipv4.addresses = [{
    #   address = "192.168.1.50";
    #   prefixLength = 24;
    # }];
    # defaultGateway = "192.168.1.1";
    # nameservers = [ "1.1.1.1" "8.8.8.8" ];

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
