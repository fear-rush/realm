{
  description = "PHP development environment with Composer";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            php84  # Change to php82, php83 as needed
            php84Packages.composer
          ];

          shellHook = ''
            echo "PHP $(php --version | head -n1) | Composer $(composer --version --no-ansi | cut -d' ' -f3)"
          '';
        };
      });
}
