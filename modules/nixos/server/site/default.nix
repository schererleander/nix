{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nx.server.site;
in
{
  imports = [
    inputs.site.nixosModules.default
  ];

  options.nx.server.site = {
    enable = mkEnableOption "personal website";
  };

  config = mkIf cfg.enable {
    services.site = {
      enable = true;
      domain = "schererleander.de";
      sslCertificate = config.sops.secrets."cert_fullchain".path;
      sslCertificateKey = config.sops.secrets."cert_private".path;
    };
  };
}
