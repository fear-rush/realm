{ config, pkgs, ... }:

{
  # Disable root login
  users.users.root.hashedPassword = "!";

  # Main user
  users.users.server = {
    isNormalUser = true;
    description = "Server Admin";
    extraGroups = [
      "wheel"
      "docker"
    ];

    # SSH public keys - REPLACE WITH YOUR KEY
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAA... your-public-key-here"
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
