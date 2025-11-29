{ unstablePkgs, ... }:

{
  environment.systemPackages = with unstablePkgs; [
    firefox
    gparted
  ];
}
