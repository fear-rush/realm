{ config, pkgs, ... }:

{
  # Immich - self-hosted photo & video backup
  services.immich = {
    enable = true;
    port = 2283;
    openFirewall = true;
    machine-learning.enable = false;
  };
}
