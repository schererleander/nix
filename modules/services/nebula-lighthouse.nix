{
  flake.modules.nixos.nebula-lighthouse = { config, ... }: {
    services.nebula.networks.mesh = {
      ca = config.sops.secrets."nebula/ca.crt".path;
      cert = config.sops.secrets."nebula/host.crt".path;
      key = config.sops.secrets."nebula/host.key".path;
      isLighthouse = true;
      isRelay = true;
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

    # Nebula authenticates peers before packets reach this interface.
    networking.firewall.trustedInterfaces = [ "nebula-mesh" ];
  };
}
