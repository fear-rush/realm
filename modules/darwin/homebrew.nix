{ ... }:

{
  homebrew = {
    enable = true;
    brews = [
      "llama.cpp"
    ];
    casks = [
      "google-chrome"
      "obsidian"
      "bruno"
      "orbstack"
      "slack"
      "discord"
      "ghostty"
      "openvpn-connect"
      "dbngin"
      "tableplus"
      "vlc"
      "claude-code"
      "zed"
      "keepassxc"
    ];
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
  };
}
