{ inputs, pkgs, lib, ... }:

{
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./zsh.nix
    ./git.nix
    ./starship.nix
    ./neovim.nix
    ./ghostty.nix
    ./direnv.nix
    ./fastfetch.nix
  ];

  home.username = "maryln";
  home.homeDirectory = lib.mkForce "/Users/maryln";
  home.stateVersion = "25.11";

  # User packages (portable to Linux)
  home.packages = with pkgs; [
    ripgrep
    fd          # Fast find alternative (used by snacks.nvim picker)
    jq
    yq-go
    fzf
    eza
    yazi
    lazyssh  # TUI SSH manager
  ];

  programs.home-manager.enable = true;
}
