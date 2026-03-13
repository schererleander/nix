{
  flake.modules.nixos.kde =
    { pkgs, ... }:
    {
      networking.networkmanager.enable = true;
      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };

      services.desktopManager.plasma6.enable = true;
      security.pam.services.sddm.enableKwallet = true;
      environment.plasma6.excludePackages = with pkgs.kdePackages; [
        elisa
        kate
      ];

      environment.variables = {
        XCURSOR_THEME = "Breeze_Snow";
        XCURSOR_SIZE = "24";
      };

      environment.systemPackages = with pkgs.kdePackages; [
        kcalc
        elisa
        kcolorchooser
        kolourpaint
      ];
    };
}
