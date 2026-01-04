{ config, lib, pkgs, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  # TODO: make it not hardcoded
  homeDir = if isDarwin then "/Users/maryln" else "/home/maryln";
  ageKeyPath = "${homeDir}/.config/sops/age/keys.txt";
in
{
  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.age.keyFile = ageKeyPath;

  # Disable SSH host key lookup (not needed on macOS)
  # not needed because i already have keyfile instead of using system /etc/ssh to ecnrypt the Key
  sops.gnupg.sshKeyPaths = [];
  sops.age.sshKeyPaths = [];

  # API Key
  sops.secrets.context7_api_key = {
    owner = "maryln";
    mode = "0400";
  };
}
