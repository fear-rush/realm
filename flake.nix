{
  description = "Maryln's Nix Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spoofdpi = {
      url = "github:xvzc/SpoofDPI";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    nixvim,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    sops-nix,
    spoofdpi,
    ...
  }: {
    darwinConfigurations = {
      "manson" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/manson.nix
          sops-nix.darwinModules.sops
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              user = "maryln";
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
              };
              mutableTaps = false;
            };
          }
          ({ config, ... }: {
            homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
          })
        ];
      };
    };

    # Future NixOS support:
    # nixosConfigurations."hostname" = nixpkgs.lib.nixosSystem { ... };

    # Future standalone home-manager (non-NixOS Linux):
    # homeConfigurations."maryln@hostname" = home-manager.lib.homeManagerConfiguration { ... };

    # Development environment templates
    # Usage: nix flake init -t ~/.config/nix#node
    templates = {
      node = {
        path = ./templates/node;
        description = "Node.js project with pnpm";
      };
      python = {
        path = ./templates/python;
        description = "Python project with uv";
      };
      rust = {
        path = ./templates/rust;
        description = "Rust project with rust-overlay";
      };
      bun = {
        path = ./templates/bun;
        description = "Bun project";
      };
    };
  };
}
