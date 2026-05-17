{
  flake.modules.nixos.font =
    { pkgs, ... }:
    {
      environment.sessionVariables = {
        FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";
      };

      fonts = {
        enableDefaultPackages = true;
        packages = with pkgs; [
          noto-fonts
          noto-fonts-cjk-sans
          liberation_ttf
          inter
          jetbrains-mono
        ];

        fontconfig = {
          enable = true;
          antialias = true;
          hinting = {
            enable = false;
            style = "none";
          };
          subpixel = {
            rgba = "none";
          };
          useEmbeddedBitmaps = false;
        };
      };
    };
}
