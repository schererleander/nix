{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.nx.server.openssh;
in
{
  options.nx.server.openssh = {
    enable = mkEnableOption "OpenSSH server";
    port = mkOption {
      description = "Port for openssh";
      type = types.port;
      default = 8693;
    };
    allowedUsers = mkOption {
      description = "Users allowed to SSH";
      type = types.listOf types.str;
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [ cfg.port ];
      settings = {
        PasswordAuthentication = false;
        AllowUsers = cfg.allowedUsers;
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
