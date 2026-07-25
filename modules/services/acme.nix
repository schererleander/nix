{
  flake.modules.nixos.acme =
    { config, ... }:
    {
      services.nginx.virtualHosts."schererleander.de" = {
        forceSSL = true;
        sslCertificate = config.sops.secrets."cert_fullchain".path;
        sslCertificateKey = config.sops.secrets."cert_private".path;
        locations."/".return = "301 https://github.com/schererleander";
      };
    };
}
