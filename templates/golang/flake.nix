{
  description = "Go development environment";

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
            go  # Change to go_1_21, go_1_22 as needed
            gopls
            golangci-lint
            delve
          ];

          shellHook = ''
            echo "Go $(go version | cut -d' ' -f3)"
          '';
        };
      });
}
