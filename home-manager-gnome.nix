{ config, pkgs, unstablePkgs, username, ... }:

{
  system.activationScripts.postSwitch = {
    text = ''
      rm /home/${username}/.config/user-dirs.dirs
    '';
  };

  home-manager.users.nightcore = {
    home.stateVersion = "25.05";
    
    xdg.userDirs = {
      enable = true;
      createDirectories = true;

      desktop        = "${config.users.users.${username}.home}/Desktop";
      documents      = "${config.users.users.${username}.home}/Documents";
      download       = "${config.users.users.${username}.home}/Downloads";
      music          = "${config.users.users.${username}.home}/Music";
      pictures       = "${config.users.users.${username}.home}/Pictures";
      publicShare    = "${config.users.users.${username}.home}/Public";
      templates      = "${config.users.users.${username}.home}/Templates";
      videos         = "${config.users.users.${username}.home}/Videos";
    };

    home.packages = with unstablePkgs; [
      htop
      gthumb
      vscode
      meld
      dconf-editor
    ];
  };
}

