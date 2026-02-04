{ config, pkgs, ... }:

{
  # Root - SSH key only
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIhjnmrkuXxq0lM2pM2WYy1WcgPXY3CLqO6bhRCd+5u1 firas"
  ];

  # Main user - SSH key only
  users.users.server = {
    isNormalUser = true;
    description = "Server Admin";
    extraGroups = [
      "wheel"
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIhjnmrkuXxq0lM2pM2WYy1WcgPXY3CLqO6bhRCd+5u1 firas"
    ];

    shell = pkgs.bash;
  };

  # Sudo - wheel group gets NOPASSWD
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };
}
