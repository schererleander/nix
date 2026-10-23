let
  lighthouse = "10.42.42.1";
  staticHostMap.${lighthouse} = [ "schererleander.de:4242" ];
  allowMesh = [
    {
      port = "any";
      proto = "any";
      host = "any";
    }
  ];
in
{
  flake.modules.darwin.lilith =
    { config, pkgs, ... }:
    let
      ca = config.sops.secrets."nebula/ca.crt".path;
      cert = config.sops.secrets."nebula/host.crt".path;
      key = config.sops.secrets."nebula/host.key".path;
      settings = (pkgs.formats.yaml { }).generate "nebula-mesh.yml" {
        pki = {
          inherit ca cert key;
        };
        static_host_map = staticHostMap;
        lighthouse = {
          am_lighthouse = false;
          hosts = [ lighthouse ];
        };
        relay = {
          use_relays = true;
          relays = [ lighthouse ];
        };
        listen = {
          host = "0.0.0.0";
          port = 4242;
        };
        punchy.punch = true;
        firewall = {
          inbound = allowMesh;
          outbound = allowMesh;
        };
      };
      start = pkgs.writeShellScript "nebula-mesh-start" ''
        # SOPS installs secrets in a separate launchd job at boot.
        while [ ! -r ${ca} ] || [ ! -r ${cert} ] || [ ! -r ${key} ]; do
          /bin/sleep 2
        done
        exec ${pkgs.nebula}/bin/nebula -config ${settings}
      '';
    in
    {
      environment.systemPackages = [ pkgs.nebula ];
      launchd.daemons.nebula-mesh.serviceConfig = {
        ProgramArguments = [ "${start}" ];
        RunAtLoad = true;
        KeepAlive = true;
        ThrottleInterval = 10;
        StandardOutPath = "/var/log/nebula-mesh.log";
        StandardErrorPath = "/var/log/nebula-mesh.log";
      };
    };
}
