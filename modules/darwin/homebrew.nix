{ ... }:

{
  homebrew = {
    enable = true;
    brews = [
      "llama.cpp"
      "platformio"
    ];
    casks = [
      "android-platform-tools"
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
      "visual-studio-code"
      "keepassxc"
    ];
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
  };
}
