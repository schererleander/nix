{
  pkgs,
  config,
  username,
  options,
  lib,
  ...
}:
let
  cfg = config.nx.server.nextcloud;
  inherit (lib) mkOption types mkIf;
in
{
  options.nx.server.nextcloud = {
    enable = mkOption {
      description = "Setup nextcloud server";
      type = types.bool;
      default = false;
    };
    adminUser = mkOption {
      description = "Admin user";
      type = types.str;
      default = "schererleander";
    };
    adminPassFile = mkOption {
      description = "Admin user key file";
      type = types.str;
      default = "/etc/nextcloud-admin-pass";
    };
    hostName = mkOption {
      description = "Nextcloud hostname";
      type = types.str;
      default = "cloud.schererleander.de";
    };
    backup = mkOption {
      description = "enable borgbase backups";
      type = types.bool;
      default = true;
    };
    jail = mkOption {
      description = "setup fail2ban jail";
      type = types.bool;
      default = config.nx.server.fail2ban.enable;
    };
  };

  config = mkIf cfg.enable {
    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud32;
      hostName = cfg.hostName;
      https = true;
      database.createLocally = true;
      maxUploadSize = "16G";
      config = {
        dbtype = "mysql";
        adminuser = cfg.adminUser;
        adminpassFile = cfg.adminPassFile;
      };
      settings = {
        maintenance_window_start = 2; # 02:00
        default_phone_region = "de";
        overwriteProtocol = "https";
        trusted_domains = [ cfg.hostName ];
        logtimezone = config.nx.server.timeZone;
        log_type = "file";
      };
      phpOptions."opcache.interned_strings_buffer" = "64";
    };

    services.nginx.virtualHosts = mkIf ((config.nx.server.nginx or { }).enable or false) {
      "${cfg.hostName}" = {
        forceSSL = true;
        sslCertificate = config.nx.server.nginx.sslCertificate;
        sslCertificateKey = config.nx.server.nginx.sslCertificateKey;
      };
    };

    services.borgbackup.jobs.nextcloud = mkIf cfg.backup {
      paths = [
        "/var/lib/nextcloud"
        "/var/lib/backup/nextcloud/db"
      ];
      repo = "h8xn8qvo@h8xn8qvo.repo.borgbase.com:repo";
      encryption.mode = "none";
      environment = {
        BORG_RSH = "ssh -i /home/${username}/.ssh/borgbase-nextcloud -o StrictHostKeyChecking=accept-new";
        TMPDIR = "/var/tmp";
      };
      compression = "auto,lzma";
      startAt = "daily";
      readWritePaths = [
        "/var/lib/backup"
        "/var/lib/nextcloud"
      ];
      preHook = ''
        set -euo pipefail
        INSTALL="${pkgs.coreutils}/bin/install"
        FIND="${pkgs.findutils}/bin/find"
        MYSQLDUMP="${pkgs.mariadb.client}/bin/mysql-dump"
        GZIP="${pkgs.gzip}/bin/gzip"
        OCC="${lib.getExe config.services.nextcloud.occ}"

        # This command requires write access to /var/lib/backup.
        $INSTALL -d -m 0750 -o root -g root /var/lib/backup/nextcloud/db

        trap "$OCC maintenance:mode --off >/dev/null 2>&1 || true" EXIT

        $OCC maintenance:mode --on

        # Make a consistent database dump without locking the site.
        $MYSQLDUMP --single-transaction --quick --lock-tables=false --databases nextcloud \
          | $GZIP -c > /var/lib/backup/nextcloud/db/nextcloud-$(date +%F-%H%M%S).sql.gz

        # Delete local dump files older than 14 days.
        $FIND /var/lib/backup/nextcloud/db -type f -name "*.sql.gz" -mtime +14 -delete || true
      '';
      postHook = ''
        set -euo pipefail
        ${lib.getExe config.services.nextcloud.occ} maintenance:mode --off || true
      '';
    };

    services.fail2ban = mkIf cfg.jail {
      jails = {
        nextcloud = {
          enabled = true;
          settings = {
            backend = "systemd";
            journalmatch = "SYSLOG_IDENTIFIER=Nextcloud";
            # END modification to work with syslog instead of logile
            port = 443;
            protocol = "tcp";
            filter = "nextcloud";
            maxretry = 3;
            bantime = 86400;
            findtime = 43200;
          };
        };
      };
    };

    environment.etc = mkIf cfg.jail {
      # Adapted failregex for syslogs
      "fail2ban/filter.d/nextcloud.local".text = pkgs.lib.mkDefault (
        pkgs.lib.mkAfter ''
          [Definition]
          _groupsre = (?:(?:,?\s*"\w+":(?:"[^"]+"|\w+))*)
          failregex = ^\{%(_groupsre)s,?\s*"remoteAddr":"<HOST>"%(_groupsre)s,?\s*"message":"Login failed:
                        ^\{%(_groupsre)s,?\s*"remoteAddr":"<HOST>"%(_groupsre)s,?\s*"message":"Trusted domain error.
          datepattern = ,?\s*"time"\s*:\s*"%%Y-%%m-%%d[T ]%%H:%%M:%%S(%%z)?"
        ''
      );
    };
  };
}
