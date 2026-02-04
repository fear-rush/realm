{ ... }:

{
  imports = [
    ./laptop.nix
    ./networking.nix
    ./portainer.nix
    ./ssh.nix
    ./users.nix
  ];

  # Enable flakes
  nix.settings.experimental-features = "nix-command flakes";
}
