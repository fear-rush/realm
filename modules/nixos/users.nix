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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBgmoF+cflWZj4a8hdMT94Xiu+/EP0nDhD2d7O5t04rR firas-android"
      "ssh-ed25519 AAAAC3NzaC1LZDI1NTESAAAAIA/EpQGRwjVCUtukotGDUZkmFGIphk89/m4FoeVtcvsm firas-pc"
    ];

    shell = pkgs.bash;
  };

  # Sudo - wheel group gets NOPASSWD
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };
}
