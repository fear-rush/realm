{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  # Hostname
  networking.hostName = "shisui";

  # Boot loader - GRUB for BIOS/MBR
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    configurationLimit = 10;
  };

  # Timezone
  time.timeZone = "Asia/Jakarta";

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    neovim
    git
    htop
    btop
    tmux
    curl
    wget
    tree
    unzip
    ripgrep
    fd
    jq
  ];

  # NixOS version - don't change after install
  system.stateVersion = "24.11";
}
