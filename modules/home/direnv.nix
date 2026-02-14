{ ... }:

{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;

    # Fast, cached nix integration
    nix-direnv.enable = true;

    # Silence verbose env diff output
    config = {
      global = {
        hide_env_diff = true;
      };
    };
  };
}
