{ pkgs, ... }:

let
  nix-clean = pkgs.writeShellScriptBin "nix-clean" ''
    set -euo pipefail

    echo "==> Wiping user profile history"
    nix profile wipe-history --older-than 0d || true
    nix-env --delete-generations old || true

    echo "==> Wiping system profile history"
    sudo nix profile wipe-history --older-than 0d || true
    sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations old || true

    echo "==> Running full garbage collection"
    sudo nix-collect-garbage -d
    nix-collect-garbage -d || true

    echo "==> Optimizing store"
    sudo nix store optimise

    echo "==> Done."
  '';
  fixflameshot = pkgs.writeShellScriptBin "fixflameshot" ''
    #!/usr/bin/env bash
    flameshot "$@"
  '';
in {
  environment.systemPackages = [ 
    nix-clean
    fixflameshot
  ];
}
