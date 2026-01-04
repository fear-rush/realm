{ ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      "$schema" = "https://starship.rs/config-schema.json";
      add_newline = true;

      character = {
        success_symbol = "[>](bold green)";
        error_symbol = "[>](bold red)";
      };

      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        read_only = " 󰌾";
      };

      git_branch = {
        symbol = " ";
        format = "[$symbol$branch]($style) ";
      };

      git_commit = {
        tag_symbol = "  ";
      };

      git_status = {
        format = "[$all_status$ahead_behind]($style) ";
      };
    };
  };
}
