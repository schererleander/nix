{
  flake.modules.nixos.plymouth =
    { lib, pkgs, ... }:
    {
      boot = {
        # Show password prompt for encrypted root
        initrd.systemd.enable = true;
        kernelParams = [ "quiet" ];
        loader.systemd-boot.consoleMode = "max";
        plymouth = {
          enable = true;
          theme = "loader_2";
          themePackages = with pkgs; [
            (adi1090x-plymouth-themes.override {
              selected_themes = [
                #"lone"
                #"red_loader"
                #"cuts_alt"
                #"abstract_ring_alt"
                "loader_2"
                #"sliced"
                #"spinner_alt"
                #"sphere"
                #"loader"
              ];
            })
          ];
        };
      };
    };
}
