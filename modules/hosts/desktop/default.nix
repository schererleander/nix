{ useHomeManager ? true, ... }:

{
  imports = [
    # NixOS-only modules (no home-manager)
    ./cinnamon
    ./gnome
    ./kde
  ] ++ (if useHomeManager then [
    # Modules that require home-manager
    ./hyprland
    ./labwc
    ./sway
    ./dunst.nix
    ./waybar.nix
  ] else [ ]);
}
