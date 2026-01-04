{
  description = "Python development environment with uv";

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
            python313  # Change to python311, python313 as needed
            uv         # Fast Python package manager
          ];

          shellHook = ''
            echo "Python $(python --version) | uv $(uv --version)"

            # Auto-create and activate venv
            # if [ ! -d .venv ]; then
            #   echo "Creating virtual environment..."
            #   uv venv
            # fi
            # source .venv/bin/activate
          '';
        };
      });
}
