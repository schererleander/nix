{
  flake.modules.nixos.acme =
    { config, ... }:
    {
      security.acme = {
        acceptTerms = true;
        defaults.server = "https://acme.ionos.com/directory";
        certs."schererleander.de" = {
          extraDomainNames = [
            "cloud.schererleander.de"
            "git.schererleander.de"
          ];
          extraLegoFlags = [ "--eab" ];
          environmentFile = config.sops.secrets."ionos-acme-env".path;
          group = "nginx";
        };
      };

      services.nginx.virtualHosts."schererleander.de" = {
        enableACME = true;
        forceSSL = true;
        locations."/".return = "301 https://github.com/schererleander";
      };
    };
}
