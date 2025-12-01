{
  description = "NixOS configuration (converted to flake)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "unstable";
  };

  outputs = { self, nixpkgs, unstable, home-manager, ... }:
    let
      system = "x86_64-linux";
      username = "nightcore";
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
            
            {
              _module.args = {
                inherit username;
                unstablePkgs = import unstable {
                  inherit system;
                  config.allowUnfree = true;
                };
              };
            }
            
            ./hardware-configuration.nix
            
            ./configuration.nix
            ./flatpak.nix
            
            ./unstable-packages.nix

            ./utils.nix
            
            home-manager.nixosModules.home-manager
            
            (import ./home-manager-gnome.nix)
          ];
        };
      };
    };
}

