{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf concatStringsSep;
  cfg = config.nx.dns;
in
{
  options.nx.dns = {
    enable = mkEnableOption "DNS-over-TLS via systemd-resolved";
    servers = mkOption {
      type = types.listOf types.str;
      default = [
        "1.1.1.1#cloudflare-dns.com"
        "1.0.0.1#cloudflare-dns.com"
        "9.9.9.9#dns.quad9.net"
        "149.112.112.112#dns.quad9.net"
      ];
    };
    fallbackServers = mkOption {
      type = types.listOf types.str;
      default = [ "8.8.8.8#dns.google" "8.8.4.4#dns.google" ];
    };
  };

    config = mkIf cfg.enable {
      services.resolved = {
        enable = true;
        settings = {
          Resolve = {
            DNS = cfg.servers;
            FallbackDNS = cfg.fallbackServers;
            DNSSEC = true;
            DNSOverTLS = true;
            Domains = [ "~." ];
          };
        };
      };
      networking = {
        nameservers = cfg.servers;
        networkmanager.dns = lib.mkDefault "systemd-resolved";
      };
      systemd.services.systemd-resolved.environment = {
        DNS = concatStringsSep " " cfg.servers;
        FallbackDNS = concatStringsSep " " cfg.fallbackServers;
      };
    };

}
