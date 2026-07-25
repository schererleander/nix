{
  flake.modules.nixos.acme =
    { config, ... }:
    {
      security.acme = {
        acceptTerms = true;
        defaults = {
          server = "https://acme.ionos.com/directory";
          extraLegoFlags = [ "--eab" ];
          environmentFile = config.sops.secrets."ionos-acme-env".path;
          group = "nginx";
        };
        certs."schererleander.de" = {
          domain = "*.schererleander.de";
        };
      };

      services.nginx.virtualHosts."schererleander.de" = {
        enableACME = true;
        forceSSL = true;
        locations."/".return = "301 https://github.com/schererleander";
      };
    };
}
