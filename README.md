# Prerequisite
Clone this repository under home directory

# Partition requirements

| LABEL         | filesystem | size                    |
|---------------|------------|-------------------------|
| nixos         | ext4       | at least 35 GB          |
| NIXOS_EFI     | fat32      | 1 GB - with "boot" flag |
| linux_shared  | ext4       | optional data partition |

# Update flake for all packages
   ```
   nix flake update
   ```

# Update flake for `unstable` packages only
   ```
   nix flake update unstable
   ```

# Build nixos
   ```
   sudo nixos-rebuild switch --flake ~/flake#nixos
   ```