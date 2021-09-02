{
  description = "Local Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, neovim, ... }: {
    homeManagerConfigurations = {
      adwin = home-manager.lib.homeManagerConfiguration {
        configuration = { pkgs, lib, ... }: {
          imports = [ ./home.nix ];
          nixpkgs = {
            overlays = [ 
              neovim.overlay 
            ];
          };
        };
        system = "x86_64-linux";
      };
    };
  };
}
