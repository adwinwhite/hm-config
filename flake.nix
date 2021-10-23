{
  description = "Local Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, neovim, rust-overlay, ... }: {
    homeConfigurations = {
      adwin = home-manager.lib.homeManagerConfiguration {
        configuration = { pkgs, lib, ... }: {
          imports = [ ./home.nix ];
          nixpkgs = {
            config.allowUnfree = true;
            overlays = [ 
              neovim.overlay 
              rust-overlay.overlay
            ];
          };
        };
        system = "x86_64-linux";
        homeDirectory = "/home/adwin";
        username = "adwin";
      };
    };
  };
}
