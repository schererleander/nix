{
  flake.modules.nixos.dns =
    { lib, ... }:
    let
      servers = [
        "1.1.1.1#cloudflare-dns.com"
        "1.0.0.1#cloudflare-dns.com"
        "9.9.9.9#dns.quad9.net"
        "149.112.112.112#dns.quad9.net"
      ];
      fallbackServers = [
        "8.8.8.8#dns.google"
        "8.8.4.4#dns.google"
      ];
    in
    {
      services.resolved = {
        enable = true;
        settings = {
          Resolve = {
            DNS = servers;
            FallbackDNS = fallbackServers;
            DNSSEC = true;
            DNSOverTLS = true;
            Domains = [ "~." ];
          };
        };
      };
      networking = {
        nameservers = servers;
        networkmanager.dns = lib.mkDefault "systemd-resolved";
      };
    };
}
