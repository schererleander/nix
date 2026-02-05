{
  flake.modules.nixos.site =
    {
      config,
      inputs,
      ...
    }:
    {
      imports = [
        inputs.site.nixosModules.default
      ];

      services.site = {
        enable = true;
        domain = "schererleander.de";
        sslCertificate = config.sops.secrets."cert_fullchain".path;
        sslCertificateKey = config.sops.secrets."cert_private".path;
      };
    };
}
