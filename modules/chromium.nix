{ config, lib, pkgs, ... }:

{
  options.chromium.enable = lib.mkEnableOption "Enable chromium and setup with extension";
  config = lib.mkIf config.chromium.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
      extensions = let
        createChromiumExtensionFor = browserVersion: { id, sha256, version }: {
          inherit id;
          crxPath = builtins.fetchurl {
            url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";
            name = "${id}.crx";
            inherit sha256;
          };
          inherit version;
        };
        createChromiumExtension = createChromiumExtensionFor (lib.versions.major pkgs.ungoogled-chromium.version);
      in [
        (createChromiumExtension {
          # ublock origin
          id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
          sha256 = "sha256:0pdh1v0vx1d5vnl1zh7nbk6j1fh4k4hhwp1ljs203icn306lahsn";
          version = "1.63.2";
        })
      ];
    };
  };
}
