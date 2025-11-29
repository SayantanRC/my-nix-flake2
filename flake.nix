{
  description = "NixOS configuration (converted to flake)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, unstable, ... }:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
          
            {
              nix.extraOptions = ''
                experimental-features = nix-command flakes
              '';
            }
            
            ./hardware-configuration.nix
            
            ./configuration.nix
            ./flatpak.nix
            
            (import ./unstable-packages.nix { 
              unstablePkgs = import unstable {
                inherit system;
                config.allowUnfree = true;
              };
            })
          ];
        };
      };
    };
}

