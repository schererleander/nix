{
  flake.modules.nixos.acme =
    { config, ... }:
    {
      security.acme = {
        acceptTerms = true;

        defaults = {
          email = "";
          server = "https://acme.ionos.com/directory";
          environmentFile = config.sops.secrets."ionos-acme-env".path;
        };

        certs."schererleander.de" = {
          domain = "schererleander.de";

          extraDomainNames = [
            "*.schererleander.de"
          ];

          dnsProvider = "ionos";
          group = "nginx";
        };
      };

      services.nginx.virtualHosts."schererleander.de" = {
        forceSSL = true;
        useACMEHost = "schererleander.de";

        locations."/".return = "301 https://github.com/schererleander";
      };
    };
}
