{
  description = "Rust development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs { inherit system overlays; };

        # Pin specific Rust version or use latest stable
        rustVersion = pkgs.rust-bin.stable.latest.default.override {
          extensions = [ "rust-src" "rust-analyzer" ];
        };
        # For specific version:
        # rustVersion = pkgs.rust-bin.stable."1.83.0".default.override { ... };
      in {
        devShells.default = pkgs.mkShell {
          packages = [
            rustVersion
          ];

          shellHook = ''
            echo "Rust $(rustc --version)"
          '';
        };
      });
}
