{ pkgs, lib, ... }:

let
  openscreen = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "openscreen";
    version = "1.0.2";

    src = pkgs.fetchurl {
      url = "https://github.com/siddharthvaddem/openscreen/releases/download/v${version}/Openscreen-mac-installer.dmg";
      sha256 = "1l2n9wc073v6345lcshil5a7jli4izk0amy0n8i9hypxhacpq0m7";
    };

    nativeBuildInputs = [ pkgs._7zz ];

    unpackPhase = ''
      7zz x $src -y
    '';

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications
      cp -r Openscreen.app $out/Applications/
      runHook postInstall
    '';

    meta = with lib; {
      description = "Free, open-source alternative to Screen Studio for screen recordings";
      homepage = "https://github.com/siddharthvaddem/openscreen";
      license = licenses.mit;
      platforms = [ "aarch64-darwin" ];
      maintainers = [];
    };
  };
in
{
  environment.systemPackages = [ openscreen ];
}
