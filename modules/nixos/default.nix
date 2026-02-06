{ ... }:

{
  imports = [
    ./laptop.nix
    ./networking.nix
    ./nextcloud.nix
    ./ssh.nix
    ./tailscale.nix
    ./users.nix
  ];

  # Enable flakes
  nix.settings.experimental-features = "nix-command flakes";

  # Garbage collection - weekly, keep last 30 days
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Deduplicate nix store
  nix.optimise.automatic = true;
}
