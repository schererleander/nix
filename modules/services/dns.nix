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
    { pkgs, lib, ... }:
    {
      environment.systemPackages = [ pkgs.cloudflared ];

      networking = {
        dns = [ "127.0.0.1" ];
        knownNetworkServices = [
          "Wi-Fi"
          "Thunderbolt Bridge"
        ];
      };

      launchd.daemons.cloudflared-dns = {
        serviceConfig = {
          Label = "com.cloudflare.cloudflared-dns";
          ProgramArguments = [
            "${pkgs.cloudflared}/bin/cloudflared"
            "proxy-dns"
            "--upstream"
            "https://dns.mullvad.net/dns-query"
            "--upstream"
            "https://dns.quad9.net/dns-query"
            "--port"
            "53"
            "--address"
            "127.0.0.1"
          ];
          RunAtLoad = true;
          KeepAlive = true;
          StandardOutPath = "/var/log/cloudflared-dns.log";
          StandardErrorPath = "/var/log/cloudflared-dns.log";
        };
      };
    };
}
