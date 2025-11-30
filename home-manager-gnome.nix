{ config, pkgs, unstablePkgs, username, ... }:

{
  system.activationScripts.postSwitch = {
    text = ''
      rm /home/${username}/.config/user-dirs.conf
      rm /home/${username}/.config/user-dirs.dirs
    '';
  };

  home-manager.users.${username} = {
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

    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Dark";
      };
    };

    dconf.enable = true;

    dconf.settings = {

      # ===================== GNOME Settings ========================

      "org/gnome/desktop/peripherals/touchpad" = {
        tap-to-click = true;
        natural-scroll = false;
      };
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "adw-gtk3-dark";
        enable-hot-corners = false;
        clock-show-seconds = true;
        clock-show-weekday = true;
        toolkit-accessibility = true;
      };
      "org/gnome/desktop/calendar" = {
        show-weekdate = true;
      };
      "org/gnome/mutter" = {
        dynamic-workspaces = false;
        edge-tiling = true;
        experimental-features = [
          "scale-monitor-framebuffer"
          "xwayland-native-scaling"
        ];
      };
      "org/gnome/shell" = {
        disable-user-extensions = false;
      };
      "org/gnome/desktop/sound" = {
        event-sounds = false;
      };
      "org/gnome/desktop/wm/preferences" = {
        button-layout = ":minimize,maximize,close";
        num-workspaces = 4;
      };
      "org/gnome/gnome-session" = {
        logout-prompt = false;
      };

      # ========================== keyboard shortcuts =========================

      "org/gnome/desktop/wm/keybindings" = {
        switch-group = [ "<Super>Tab" ];
        switch-applications = [ "<Super>Grave" ];
        switch-windows = [ "<Alt>Tab" ];
        close = [ "<Shift><Alt>q" ];
      };
      "org/gnome/shell/keybindings" = {
        screenshot = [ ];
        show-screenshot-ui = [ ];
        focus-active-notification = [ ];
        toggle-message-tray = [ "<Super>n" ];
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        home = [ "<Super>e" ];
        logout = [ ];
        calculator = [ "<Super>c" ];
      };

      # ========================= custom shortcuts ==========================

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/"
        ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        name = "Firefox";
        command = "firefox";
        binding = "<Super>f";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        name = "Firefox private";
        command = "firefox --private-window";
        binding = "<Alt><Super>f";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
        name = "Firefox /e/";
        command = "firefox -p /e/";
        binding = "<Super><Shift>f";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
        name = "LibreWolf flatpak";
        command = "flatpak run io.gitlab.librewolf-community";
        binding = "<Super>w";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
        name = "Kill gradle";
        command = "pkill -f '.*GradleDaemon.*'";
        binding = "<Super><Shift>g";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5" = {
        name = "Terminal";
        command = "kgx";
        binding = "<Super>t";
      };
    };
  };
}

