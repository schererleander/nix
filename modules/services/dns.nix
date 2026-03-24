{
  flake.modules.nixos.dns =
    { lib, ... }:
    let
      servers = [
        "194.242.2.2#dns.mullvad.net"
        "2a07:e340::2#dns.mullvad.net"
      ];
      fallbackServers = [
        "1.1.1.1#cloudflare-dns.com"
        "1.0.0.1#cloudflare-dns.com"
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
      # Workaround mullvad dns REFUSED response
      networking.hosts = {
        "216.58.206.78" = [ "www.youtube.com" ];
      };
    };

  flake.modules.darwin.dns =
    { lib, ... }:
    {
      services.dnscrypt-proxy = {
        enable = true;
        settings = {
          listen_addresses = [ "127.0.0.1:53" ];
          server_names = [
            "mullvad-doh"
            "quad9-doh-ip4-filter-pri"
          ];
          fallback_resolvers = [
            "9.9.9.9:53"
            "1.1.1.1:53"
          ];
          ignore_system_dns = true;
          sources.public-resolvers = {
            urls = [
              "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
              "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
            ];
            cache_file = "/var/tmp/public-resolvers.md";
            minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
          };
        };
      };

      users.users._dnscrypt-proxy.home = lib.mkForce "/private/var/lib/dnscrypt-proxy";

      # Run as root so it can bind privileged port 53
      launchd.daemons.dnscrypt-proxy.serviceConfig = {
        UserName = lib.mkForce null;
        GroupName = lib.mkForce null;
      };

      networking = {
        dns = [ "127.0.0.1" ];
        knownNetworkServices = [
          "Wi-Fi"
          "Thunderbolt Bridge"
        ];
      };
    };
}
