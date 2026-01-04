{ config, pkgs, lib, ... }:

{
  programs.fastfetch = {
    enable = true;
    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

      logo = {
        type = "file";
        source = "${config.home.homeDirectory}/.config/nix/ascii/itachi5.txt";
        padding = {
          top = 2;
          left = 0;
          right = 2;
        };
      };

      display = {
        separator = "  ";
        key = {
          width = 10;
          paddingLeft = 0;
        };
        color = {
          keys = "31";
          title = "91";
          separator = "90";
        };
        percent = {
          type = 9;
        };
      };

      modules = [
        {
          type = "title";
          format = "{#91}{user-name}{#90}@{#91}{host-name}{#}";
        }
        {
          type = "custom";
          format = "{#90}─────────────────────────{#}";
        }
        "break"

        { type = "os"; key = "OS"; }
        { type = "kernel"; key = "Kernel"; }
        { type = "host"; key = "Host"; }
        { type = "uptime"; key = "Uptime"; }
        "break"

        { type = "cpu"; key = "CPU"; }
        { type = "gpu"; key = "GPU"; }
        { type = "memory"; key = "Memory"; }
        { type = "disk"; key = "Disk"; folders = "/"; }
        { type = "display"; key = "Display"; }
        { type = "battery"; key = "Battery"; }
        "break"

        { type = "shell"; key = "Shell"; }
        { type = "terminal"; key = "Terminal"; }
        { type = "wm"; key = "WM"; }
        { type = "packages"; key = "Packages"; }
        "break"

        { type = "localip"; key = "Local IP"; showIpv4 = true; }
        { type = "locale"; key = "Locale"; }
        "break"

        {
          type = "colors";
          paddingLeft = 2;
          symbol = "circle";
        }
      ];
    };
  };
}
