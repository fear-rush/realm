{ ... }:

# Sometimes the system is still stuck even with correct nix-darwin configuration.
# so always check it again and if still stuck then adjust it using macOS `default` command
# example: when i try to set the dock static to true and then i turn it off, dock static still true
# and i must manually turn it off using `defaults write com.apple.dock "static-only" -bool "false" && killall Dock`
# source: https://macos-defaults.com/dock/static-only.html#set-to-true
{
  system.defaults = {
    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
    };

    dock = {
      autohide = true;
      show-recents = false;
      tilesize = 48;
      persistent-apps = [
        "/Applications/Google Chrome.app"
        "/Applications/Slack.app"
        "/Applications/Obsidian.app"
        "/Applications/Bruno.app"
        "/Applications/OpenVPN Connect.app"
        "/Applications/Discord.app"
      ];
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      FXPreferredViewStyle = "Nlsv";
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    controlcenter = {
      BatteryShowPercentage = true;
    };

    NSGlobalDomain = {
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticInlinePredictionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSTableViewDefaultSizeMode = 1;
    };
  };
}
