{ inputs, ... }:
{
  flake.modules.homeManager.quickshell =
    { pkgs, config, ... }:
    {
      home.packages = [ 
        pkgs.inter
        pkgs.brightnessctl
        pkgs.adwaita-icon-theme
        pkgs.hicolor-icon-theme
      ];

      programs.quickshell = {
        enable = true;
        package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
        activeConfig = "bar";
        configs.bar = ./quickshell;
        systemd.enable = true;
      };

      systemd.user.services.quickshell = {
        Service.Environment = [
          "PATH=${pkgs.sway}/bin:${pkgs.pipewire}/bin:${pkgs.wireplumber}/bin:${pkgs.brightnessctl}/bin:${config.home.profileDirectory}/bin:/run/current-system/sw/bin"
          "XDG_DATA_DIRS=${pkgs.adwaita-icon-theme}/share:${pkgs.hicolor-icon-theme}/share:${config.home.profileDirectory}/share:/run/current-system/sw/share"
        ];
      };
    };

  flake.modules.nixos.quickshell =
    { pkgs, ... }:
    {
      security.pam.services.quickshell = {
        text = ''
          auth required pam_unix.so
          account required pam_unix.so
        '';
      };
    };
}
