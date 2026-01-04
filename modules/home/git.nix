{ pkgs, ... }:

let
  personal = {
    name = "Muhammad Firas";
    email = "muhfiras1@gmail.com";
    signingKey = "~/.ssh/id_ed25519.pub";
  };

  # TODO: Uncomment when work account is needed
  # work = {
  #   name = "Your Work Name";
  #   email = "your.work@company.com";
  #   signingKey = "~/.ssh/id_ed25519_work.pub";
  # };
in
{
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      aliases = {
        co = "pr checkout";
        pv = "pr view";
      };
    };
  };

  programs.gh-dash.enable = true;

  programs.git = {
    enable = true;

    # SSH commit signing
    signing = {
      format = "ssh";
      key = personal.signingKey;
      signByDefault = true;
    };

    # All git config in unified settings block (new style)
    settings = {
      user = {
        name = personal.name;
        email = personal.email;
      };

      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;

      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";

      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        lg = "log --oneline --graph --decorate";
        a = "add";
        ca = "commit --amend";
        can = "commit --amend --no-edit";
        fa = "fetch --all";
      };
    };

    # TODO: Uncomment when work account is needed
    # includes = [
    #   {
    #     condition = "gitdir:~/work/";
    #     contents = {
    #       user = {
    #         name = work.name;
    #         email = work.email;
    #         signingKey = work.signingKey;
    #       };
    #     };
    #   }
    # ];
  };
}
