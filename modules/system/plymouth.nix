{
  flake.modules.nixos.plymouth =
    { pkgs, ... }:
    {
      boot = {
        # Show password prompt for encrypted root
        initrd.systemd.enable = true;
        kernelParams = [ "quiet" ];
        loader.systemd-boot.consoleMode = "max";
        plymouth = {
          enable = true;
          theme = "breeze";
          themePackages = with pkgs; [
            kdePackages.breeze-plymouth
          ];
        };
      };
    };
}
