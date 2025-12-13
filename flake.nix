{
  description = "NixOS configuration (converted to flake)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "unstable";

    # For asus X13
    # Found from commit history of https://github.com/NixOS/nixpkgs/commits/nixos-unstable/pkgs/os-specific/linux/kernel/kernels-org.json
    nixpkgs-611.url = "github:NixOS/nixpkgs/4f8728c893b698b0285c57037323f783824b1e25";
  };

  outputs = { self, nixpkgs, unstable, nixpkgs-611, home-manager, ... }:
    let
      system = "x86_64-linux";
      username = "nightcore";
      lib = nixpkgs.lib;

      baseArgs = {
        inherit username;
        unstablePkgs = import unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };

      baseModules = [
        ({ ... }: {
          nix.extraOptions = ''
            experimental-features = nix-command flakes
          '';
        })

        ({ ... }: (let inherit baseArgs; in {
          _module.args = baseArgs;
        }))

        ./hardware-configuration.nix
        ./configuration.nix
        ./flatpak.nix
        ./unstable-packages.nix
        ./utils.nix
        home-manager.nixosModules.home-manager
        (import ./home-manager-gnome.nix)
      ];
    in {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = baseModules ++ [
            ({config, pkgs, ... }: {
              boot.kernelPackages = pkgs.linuxPackages_latest;
            })
          ];
        };

        asusX13 = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = baseModules ++ [
            {
              _module.args = {
                pkgs611 = import nixpkgs-611 {
                  inherit system;
                };
              };
            }

            ({config, pkgs, pkgs611, ... }: {
              boot.kernelPackages = pkgs611.linuxPackages_6_11;
            })
          ];
        };

        thinkpad_X9_15 = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = baseModules ++ [
            ({config, lib, unstablePkgs, ... }: {
              boot.kernelPackages = unstablePkgs.linuxPackages_latest;
              boot.initrd.availableKernelModules = lib.mkAfter [ "thunderbolt" ];
              boot.kernelModules = lib.force [ "kvm-intel" ];
            })
          ];
        };
      };
    };
}

