# home-manager/sayantan.nix
{ config, pkgs, ... }:

{
  home-manager.users.nightcore = {
    home.stateVersion = "25.05";

    home.packages = with pkgs; [
      htop
      mate.caja
    ];
  };
}

