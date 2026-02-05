{
  flake.modules.nixos.nextcloud =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      services.nextcloud = {
        enable = true;
        package = pkgs.nextcloud32;
        hostName = "cloud.schererleander.de";
        https = true;
        database.createLocally = true;
        maxUploadSize = "16G";
        config = {
          dbtype = "mysql";
          adminuser = "schererleander";
          adminpassFile = config.sops.secrets."nextcloud-admin-pass".path;
        };
        secretFile = config.sops.secrets."nextcloud-secrets".path;
        settings = {
          maintenance_window_start = 2; # 02:00
          default_phone_region = "de";
          overwriteProtocol = "https";
          trusted_domains = [ "cloud.schererleander.de" ];
          logtimezone = config.time.timeZone;
          log_type = "file";
          # Disable mail functionality for single-user instance
          mail_smtpmode = "null";
        };
        phpOptions."opcache.interned_strings_buffer" = "32";
      };

      # Reduce memory usage
      services.phpfpm.pools.nextcloud = {
        settings = {
          "pm" = lib.mkForce "ondemand";
          "pm.max_children" = lib.mkForce "3";
          "pm.process_idle_timeout" = lib.mkForce "10s";
          "pm.max_requests" = lib.mkForce "500";
        };
      };
      services.nextcloud.phpOptions = {
        memory_limit = lib.mkForce "512M";
      };

      # Reduce memory usage
      services.mysql.settings = {
        mysqld = {
          innodb_buffer_pool_size = "128M";
          innodb_log_buffer_size = "8M";
          key_buffer_size = "8M";
          max_connections = "20"; # Reduce from default 151
          table_open_cache = "32";
          query_cache_size = "0"; # Disable query cache
          performance_schema = "OFF";
        };
      };

      services.nginx.virtualHosts = {
        "cloud.schererleander.de" = {
          forceSSL = true;
          sslCertificate = config.sops.secrets."cert_fullchain".path;
          sslCertificateKey = config.sops.secrets."cert_private".path;
        };
      };

      services.borgbackup.jobs.nextcloud = {
        paths = [
          "/var/lib/nextcloud"
          "/var/lib/backup/nextcloud/db"
        ];
        repo = "$BORG_REPO";
        encryption.mode = "none";
        user = "root";
        group = "root";
        environment = {
          BORG_RSH = "ssh -i ${
            config.sops.secrets."borgbase_ssh_key".path
          } -o StrictHostKeyChecking=accept-new";
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

          export BORG_REPO="$(cat ${config.sops.secrets."borg_repo".path})"

          INSTALL="${pkgs.coreutils}/bin/install"
          FIND="${pkgs.findutils}/bin/find"
          MYSQLDUMP="${pkgs.mariadb.client}/bin/mariadb-dump"
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

      services.fail2ban = {
        enable = true;
        bantime = lib.mkDefault "1h";
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
              findtime = 43200;
            };
          };
        };
      };

      environment.etc = {
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
