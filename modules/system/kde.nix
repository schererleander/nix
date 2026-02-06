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
      environment.systemPackages = with pkgs.kdePackages; [
        kcalc
        elisa
      ];
    };
}
