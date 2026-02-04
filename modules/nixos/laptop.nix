{ config, pkgs, ... }:

{
  # Hardware optimizations for laptop as server (i3-2310M, 8GB DDR3, 464GB HDD)

  # Power management
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand";
  };

  # Thermal management
  services.thermald.enable = true;

  # Ignore lid close - keep running when lid is closed
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
    HandlePowerKey = "ignore";
  };

  # Disable sleep/suspend
  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  # Disable Bluetooth (not needed for server)
  hardware.bluetooth.enable = false;

  # Disable sound (not needed for server)
  services.pulseaudio.enable = false;

  # Disable GUI - headless server
  services.xserver.enable = false;
  services.displayManager.enable = false;

  # Firmware updates
  hardware.enableRedistributableFirmware = true;

  # Kernel tweaks for i3-2310M server workload (8GB DDR3)
  boot.kernel.sysctl = {
    # Network performance
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_max" = 16777216;
    "net.ipv4.tcp_rmem" = "4096 87380 16777216";
    "net.ipv4.tcp_wmem" = "4096 65536 16777216";

    # Allow more connections
    "net.core.somaxconn" = 65535;
    "net.ipv4.tcp_max_syn_backlog" = 65535;

    # VM tweaks for 8GB RAM with HDD
    "vm.swappiness" = 10;
    "vm.dirty_ratio" = 60;
    "vm.dirty_background_ratio" = 2;
  };

  # Swap partition
  swapDevices = [{
    device = "/dev/sda2";
  }];
}
