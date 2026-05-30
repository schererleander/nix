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
            #(adi1090x-plymouth-themes.override {
            #selected_themes = [
            #"lone"
            #"red_loader"
            #"cuts_alt"
            #"abstract_ring_alt"
            #"loader_2"
            #"sliced"
            #"spinner_alt"
            #"sphere"
            #"loader"
            #];
            #})
            kdePackages.breeze-plymouth
          ];
        };
      };
    };
}
