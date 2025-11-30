{ unstablePkgs, ... }:

{
  environment.systemPackages = with unstablePkgs; [
    firefox
    gparted
    adw-gtk3
    steam-run
    appimage-run
    dmidecode
    usbutils
    coreutils-full
    fuse
    tree
    exfatprogs
    ntfs3g
    p7zip
    unrar
  ];
}
