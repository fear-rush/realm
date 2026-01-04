{ ... }:

{
  # Ghostty config file
  # Ghostty is installed via homebrew cask because doesn't have aarch64-darwin in nixpkgs, but config is managed here
  home.file.".config/ghostty/config".text = ''
    font-family = Hack Nerd Font
    font-size = 14

    theme = TokyoNight

    window-padding-x = 10
    window-padding-y = 10

    cursor-style = block
    cursor-style-blink = false

    copy-on-select = true
    confirm-close-surface = false

    macos-option-as-alt = true

    # SSH: copy terminfo to remote servers, fallback to xterm-256color if failed
    shell-integration-features = ssh-terminfo,ssh-env
  '';

}
