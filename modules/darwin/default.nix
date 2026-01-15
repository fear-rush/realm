{ ... }:

{
  imports = [
    ./system.nix
    ./aerospace.nix
    ./homebrew.nix
    ./nix.nix
    ./openscreen.nix
    ./devtools.nix
    ../shared/sops.nix
  ];

  # Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;
}
