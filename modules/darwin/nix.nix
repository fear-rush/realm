{ ... }:

{
  # Manual garbage collection (run: sudo nix-collect-garbage --delete-older-than 14d)
  nix.gc = {
    automatic = false;
    options = "--delete-older-than 14d";
  };

  # Manual store optimization (run: nix-store --optimise)
  nix.optimise = {
    automatic = false;
  };

  # Keep devenv/direnv shells from being garbage collected
  nix.settings = {
    keep-outputs = true;
    keep-derivations = true;
  };
}
