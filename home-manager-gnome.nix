{ config, pkgs, unstablePkgs, username, lib, ... }:

{
  system.activationScripts.postSwitch = {
    text = ''
      rm /home/${username}/.config/user-dirs.conf
      rm /home/${username}/.config/user-dirs.dirs
    '';
  };

  environment.systemPackages = with pkgs; [
    gjs
    binutils
    nautilus
  ];
  environment.sessionVariables = {
    GI_TYPELIB_PATH = lib.makeSearchPath "lib/girepository-1.0" [
      pkgs.gtk3
    ];
  };
  # GSettings schemas of all apps are not made global unless they are declared here.
  # Visible schemas paths can be seen by `echo $XDG_DATA_DIRS | tr ":" "\n"`
  # Add the apps whose schemas are to be made global in this block.
  # https://github.com/NixOS/nixpkgs/issues/33277#issuecomment-354714431
  services.xserver.desktopManager.gnome.extraGSettingsOverridePackages = [
    pkgs.nautilus
  ];

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

    home.packages = (with unstablePkgs; [
      htop
      gthumb
      vscode
      meld
      dconf-editor
      gnome-extension-manager
      baobab
      gnome-disk-utility
      stress
      pavucontrol
      gsmartcontrol
      pv
      pciutils
      lshw
      libnotify
      smartmontools
      dig
      x265
      exiftool
    ]) ++ (with pkgs; [
      gnomeExtensions.touchpad-gesture-customization
      gnomeExtensions.vitals
      gnomeExtensions.clipboard-history
      gnomeExtensions.app-icons-taskbar
      gnomeExtensions.just-perfection
      gnomeExtensions.caffeine
      gnomeExtensions.desktop-icons-ng-ding
      gnomeExtensions.transparent-top-bar-adjustable-transparency
      gnomeExtensions.emoji-copy
      gnomeExtensions.bluetooth-battery-meter
      gnomeExtensions.blur-my-shell
      gnomeExtensions.net-speed-simplified
      gnomeExtensions.status-area-horizontal-spacing
      gnomeExtensions.lilypad
      gnomeExtensions.appindicator
    ]);

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

      # ================================== extensions ===============================
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "touchpad-gesture-customization@coooolapps.com"
          "Vitals@CoreCoding.com"
          "clipboard-history@alexsaveau.dev"
          "aztaskbar@aztaskbar.gitlab.com"
          "just-perfection-desktop@just-perfection"
          "caffeine@patapon.info"
          "ding@rastersoft.com"
          "transparent-top-bar@ftpix.com"
          "emoji-copy@felipeftn"
          "Bluetooth-Battery-Meter@maniacx.github.com"
          "blur-my-shell@aunetx"
          "netspeedsimplified@prateekmedia.extension"
          "lilypad@shendrew.github.io"
          "status-area-horizontal-spacing@mathematical.coffee.gmail.com"
          "appindicatorsupport@rgcjonas.gmail.com"
        ];
      };
      
      "org/gnome/shell/extensions/touchpad-gesture-customization" = {
        allow-minimize-window = true;
        follow-natural-scroll = false;
        overview-navigation-states = "CYCLIC";
        vertical-swipe-3-fingers-gesture = "WINDOW_MANIPULATION";
        vertical-swipe-4-fingers-gesture = "OVERVIEW_NAVIGATION";
      };

      "org/gnome/shell/extensions/vitals" = {
        fixed-widths = true;
        hot-sensors = [
          "__temperature_max__"
          "__fan_max__"
        ];
        icon-style = 0;
        include-static-gpu-info = true;
        show-battery = true;
        show-fan = true;
        show-gpu = true;
        show-memory = true;
        show-network = true;
        show-processor = true;
        show-storage = true;
        show-system = true;
        show-temperature = true;
        show-voltage = true;
        update-time = 1;
      };

      "org/gnome/shell/extensions/clipboard-history" = {
        paste-on-selection = false;
        toggle-private-mode = [];
        topbar-preview-size = 30;
        toggle-menu = [ "<Super>v" ];
      };

      "org/gnome/shell/extensions/aztaskbar" = {
        click-action = "CYCLE";
        dance-urgent = true;
        favorites = true;
        isolate-workspaces = false;
        multi-window-indicator-style = "MULTI_DASH";
        panel-location = "TOP";
        peek-windows = false;
        position-in-panel = "LEFT";
        show-apps-button = lib.gvariant.mkTuple [ 
          true 
          (lib.gvariant.mkInt32 0) 
        ];
        tool-tips = true;
        window-previews = false;
        hide-dash = false;
      };

      "org/gnome/shell/extensions/just-perfection" = {
        weather = false;
        window-demands-attention-focus = true;
        world-clock = false;
        startup-status = 0;
        quick-settings-airplane-mode = false;
        quick-settings-dark-mode = false;
        quick-settings-night-light = false;
      };

      "org/gnome/shell/extensions/caffeine" = {
        indicator-position-max = 1;
        show-indicator = "only-active";
      };

      "org/gnome/shell/extensions/ding" = {
        dark-text-in-labels = false;
        show-home = false;
        show-network-volumes = false;
        show-trash = false;
        show-volumes = true;
        start-corner = "bottom-left";
      };

      "com/ftpix/transparentbar" = {
        transparency = 0;
      };

      "org/gnome/shell/extensions/emoji-copy" = {
        always-show = true;
        emoji-keybind = [ "<Super>Period" ];
        active-keybind = true;
      };

      "org/gnome/shell/extensions/Bluetooth-Battery-Meter" = {
        enable-battery-indicator = true;
        enable-battery-level-text = true;
        swap-icon-text = false;
        enable-upower-level-icon = true;
      };

      "org/gnome/shell/extensions/blur-my-shell/panel" = {
        blur = false;
      };

      "org/gnome/shell/extensions/netspeedsimplified" = {
        chooseiconset = 2;
        fontmode = 1;
        hideindicator = false;
        isvertical = true;
        lockmouseactions = true;
        minwidth = 5.0;
        mode = 3;
        refreshtime = 1.0;
        togglebool = false;
        wposext = 1;
      };

      "org/gnome/shell/extensions/status-area-horizontal-spacing" = {
        hpadding = 4;
      };

      "org/gnome/shell/extensions/lilypad" = {
        lilypad-order = [
          "Clipboard_History_Indicator"
          "emoji_copy"
        ];
        reorder = true;
        rightbox-order = [
          "ShowNetSpeedButton"
          "lilypad"
          "vitalsMenu"
          "StatusNotifierItem"
        ];
      };
    };
  };
}

