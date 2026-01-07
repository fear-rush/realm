{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.aerospace ];

  services.aerospace = {
    enable = true;
    settings = {
      config-version = 2;
      after-startup-command = [];
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";
      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
      automatically-unhide-macos-hidden-apps = false;
      persistent-workspaces = [ "1" "2" "3" "4" "5" "c" "m" "t" "e" ];
      on-mode-changed = [];
      accordion-padding = 30;

      key-mapping = {
        preset = "qwerty";
      };

      gaps = {
        outer.left = 8;
        outer.bottom = 8;
        outer.top = 8;
        outer.right = 8;
      };

      mode.main.binding = {
        alt-slash = "layout tiles horizontal vertical";
        alt-comma = "layout accordion horizontal vertical";
        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";
        alt-shift-h = "move left";
        alt-shift-j = "move down";
        alt-shift-k = "move up";
        alt-shift-l = "move right";
        alt-minus = "resize smart -50";
        alt-equal = "resize smart +50";
        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-5 = "workspace 5";
        alt-c = "workspace c";
        alt-m = "workspace m";
        alt-t = "workspace t";
        alt-e = "workspace e";
        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";
        alt-shift-5 = "move-node-to-workspace 5";
        alt-shift-c = "move-node-to-workspace c";
        alt-shift-m = "move-node-to-workspace m";
        alt-shift-t = "move-node-to-workspace t";
        alt-shift-e = "move-node-to-workspace e";
        alt-shift-f = "fullscreen";
        alt-tab = "workspace-back-and-forth";
        alt-shift-tab = "move-workspace-to-monitor --wrap-around next";
        alt-shift-semicolon = "mode service";
      };

      mode.service.binding = {
        esc = [ "reload-config" "mode main" ];
        r = [ "flatten-workspace-tree" "mode main" ];
        f = [ "layout floating tiling" "mode main" ];
        backspace = [ "close-all-windows-but-current" "mode main" ];
        alt-shift-h = [ "join-with left" "mode main" ];
        alt-shift-j = [ "join-with down" "mode main" ];
        alt-shift-k = [ "join-with up" "mode main" ];
        alt-shift-l = [ "join-with right" "mode main" ];
      };

      # fix bug when opening a new tab or duplicate using ghostty
      # source: https://github.com/nikitabobko/AeroSpace/issues/778
      on-window-detected = [
        {
          "if" = {
            app-id = "com.mitchellh.ghostty";
          };
          run = ["layout floating" "move-node-to-workspace t"];
        }
      ];
    };
  };
}
