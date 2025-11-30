{ unstablePkgs, ... }:

{
  environment.systemPackages = with unstablePkgs; [
    firefox
    gparted
    adw-gtk3
  ];
}
