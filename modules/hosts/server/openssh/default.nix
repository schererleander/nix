{
  config,
  username,
  lib,
  ...
}:
let
  cfg = config.nx.server.openssh;
  inherit (lib) mkOption types mkIf;
in
{
  options.nx.server.openssh = {
    enable = mkOption {
      description = "Setup openssh for server";
      type = types.bool;
      default = false;
    };
    port = mkOption {
      description = "Port for openssh";
      type = types.port;
      default = 8693;
    };
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [ cfg.port ];
      settings = {
        PasswordAuthentication = false;
        AllowUsers = [ username ];
        X11Forwarding = false;
        PermitRootLogin = "yes";
      };
    };
    networking.firewall.allowedTCPPorts = [ cfg.port ];

    services.fail2ban = {
      jails = {
        sshd = {
          enabled = true;
          settings = {
            port = 8693;
            backend = "systemd";
            maxretry = 4;
            findtime = "10m";
            bantime = "1h";
          };
        };
      };
    };
  };
}
