{ unstablePkgs, ... }:

{
  environment.systemPackages = with unstablePkgs; [
    firefox
    vscode
    gthumb
  ];
}
