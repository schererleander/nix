{ config, lib, pkgs, ... }:

let
  cfg = config.chromium;
in {
  options.chromium.enable = lib.mkEnableOption "Enable chromium and setup with extension";
  config = lib.mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
      extensions =
        let
          createChromiumExtensionFor = browserVersion: { id, sha256, version }:
      {
        inherit id;
        crxPath = builtins.fetchurl {
          url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";
          name = "${id}.crx";
          inherit sha256;
        };
        inherit version;
      };
    createChromiumExtension = createChromiumExtensionFor (lib.versions.major package.version);
  in
  [
    (createChromiumExtension {
      # ublock origin
      id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
      sha256 = "sha256-u81DNkZw/LBVyjk5nmrrJEVjdc+GFCay+rQZGpDH3jA=";
      version = "1.37.2";
    })
   ];
  };
 };
}
  
