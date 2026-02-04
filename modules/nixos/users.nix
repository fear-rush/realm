{ config, pkgs, ... }:

{
  # Root - SSH key only
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIhjnmrkuXxq0lM2pM2WYy1WcgPXY3CLqO6bhRCd+5u1 firas"
  ];

  # Main user - password auth via SSH
  users.users.server = {
    isNormalUser = true;
    description = "Server Admin";
    extraGroups = [
      "wheel"
    ];

    shell = pkgs.bash;
  };

  # Sudo configuration
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;

    extraRules = [
      {
        users = [ "server" ];
        commands = [
          { command = "ALL"; options = [ "NOPASSWD" ]; }
        ];
      }
    ];
  };
}
