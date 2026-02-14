{ inputs, pkgs, lib, ... }:

{
  imports = [
    ./direnv.nix
    ./git.nix
  ];

  home.username = "server";
  home.homeDirectory = "/home/server";
  home.stateVersion = "24.11";

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.home-manager.enable = true;
}
