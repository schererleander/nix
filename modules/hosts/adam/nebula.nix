{
  flake.modules.nixos.adam = { config, ... }: {
    services.nebula.networks.mesh = {
      ca = config.sops.secrets."nebula/ca.crt".path;
      cert = config.sops.secrets."nebula/host.crt".path;
      key = config.sops.secrets."nebula/host.key".path;
      lighthouses = [ "10.42.42.1" ];
      staticHostMap."10.42.42.1" = [ "schererleander.de:4242" ];
      relays = [ "10.42.42.1" ];
      listen.port = 4242;
      tun.device = "nebula-mesh";
      firewall = {
        inbound = [
          {
            port = "any";
            proto = "any";
            host = "any";
          }
        ];
        outbound = [
          {
            port = "any";
            proto = "any";
            host = "any";
          }
        ];
      };
      settings.punchy.punch = true;
    };

    networking.firewall.trustedInterfaces = [ "nebula-mesh" ];
  };
}
