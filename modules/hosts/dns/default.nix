{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkOption types mkIf;
  cfg = config.nx.dns;
in
{
  options.nx.dns = {
    enable = mkOption {
      description = "enable DNS-over-TLS using systemd-resolved";
      type = types.bool;
      default = false;
    };
    servers = mkOption {
      description = "list of DNS-over-TLS servers to use";
      type = types.listOf types.str;
      default = [
        "1.1.1.1#cloudflare-dns.com"
        "1.0.0.1#cloudflare-dns.com"
        "9.9.9.9#dns.quad9.net"
        "149.112.112.112#dns.quad9.net"
      ];
    };
    fallbackServers = mkOption {
      description = "fallback DNS servers";
      type = types.listOf types.str;
      default = [
        "8.8.8.8#dns.google"
        "8.8.4.4#dns.google"
      ];
    };
  };

  config = mkIf cfg.enable {
    services.resolved = {
      enable = true;
      dnssec = "true";
      dnsovertls = "true";
      domains = [ "~." ];
      extraConfig = ''
        DNSStubListener=yes
        Cache=yes
      '';
    };

    networking = {
      nameservers = cfg.servers;
      networkmanager.dns = lib.mkDefault "systemd-resolved";
    };

    systemd.services.systemd-resolved.environment = {
      DNS = lib.concatStringsSep " " cfg.servers;
      FallbackDNS = lib.concatStringsSep " " cfg.fallbackServers;
    };
  };
}
