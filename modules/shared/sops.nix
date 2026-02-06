{ config, lib, pkgs, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  homeDir = if isDarwin then "/Users/maryln" else "/home/server";
  ageKeyPath = "${homeDir}/.config/sops/age/keys.txt";
in
{
  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.age.keyFile = ageKeyPath;

  # Disable SSH host key lookup (using age keyfile instead)
  sops.gnupg.sshKeyPaths = [];
  sops.age.sshKeyPaths = [];

  # Platform-specific secrets
  sops.secrets = lib.mkMerge [
    # Darwin (macOS) secrets
    (lib.mkIf isDarwin {
      context7_api_key = {
        owner = "maryln";
        mode = "0400";
      };
    })
  ];
}
