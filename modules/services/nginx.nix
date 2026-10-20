{
  flake.modules.nixos.nginx = {
    services.nginx = {
      enable = true;
      recommendedGzipSettings = false;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      appendHttpConfig = ''
        map $scheme $hsts_header {
            https   "max-age=31536000; includeSubdomains; preload";
        }
        add_header Strict-Transport-Security $hsts_header;
      '';
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    networking.firewall.allowedUDPPorts = [
      443
    ];

    services.nginx.virtualHosts."schererleander.de" = {
      forceSSL = true;
      useACMEHost = "schererleander.de";
      quic = true;

      locations."/".return = "301 https://github.com/schererleander";
    };
  };
}
