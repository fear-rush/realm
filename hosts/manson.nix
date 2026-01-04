{ inputs, pkgs, config, ... }:

{
  imports = [
    ../modules/darwin
  ];

  # System-level packages (not user-specific)
  environment.systemPackages = with pkgs; [
    zip
    xz
    unzip
    p7zip
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg
  ];

  # Fonts
  fonts.packages = [
    pkgs.nerd-fonts.hack
  ];

  # Home-manager configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.maryln = import ../modules/home;
  };

  # Nix settings
  nix.settings.experimental-features = "nix-command flakes";

  # System state version
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = 6;

  # Platform
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Primary user for this machine
  system.primaryUser = "maryln";
}
