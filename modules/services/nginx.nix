{
  flake.modules.nixos.nginx =
    { ... }:
    {
      services.nginx = {
        enable = true;
        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        appendHttpConfig = ''
          map $scheme $hsts_header {
              https   "max-age=31536000; includeSubdomains; preload";
          }
          add_header Strict-Transport-Security $hsts_header;
          #add_header Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self'; img-src 'self' data:; font-src 'self'; connect-src 'self'; object-src 'none'; frame-ancestors 'none'; base-uri 'self';" always;
          add_header 'Referrer-Policy' 'same-origin';
          add_header X-Frame-Options DENY;
          add_header X-Content-Type-Options nosniff;
        '';
      };
      networking.firewall.allowedTCPPorts = [
        80
        443
      ];
    };
}
