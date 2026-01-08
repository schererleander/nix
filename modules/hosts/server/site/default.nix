{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.nx.server.site;
  inherit (lib) mkOption types mkIf;
in
{
  imports = [
    inputs.site.nixosModules.default
  ];

  options.nx.server.site = {
    enable = mkOption {
      description = "Setup personal website";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.site = {
      enable = true;
      domain = "schererleander.de";
      sslCertificate = "/etc/ssl/schererleander.de/fullchain.pem";
      sslCertificateKey = "/etc/ssl/schererleander.de/privkey.key";
    };
  };
}
