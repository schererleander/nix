{
  flake.modules.nixos.font =
    { pkgs, ... }:
    {
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
            enable = true;
            autohint = false;
            style = "slight";
          };
          subpixel = {
            rgba = "none";
          };
          useEmbeddedBitmaps = false;
        };
      };
    };
}
