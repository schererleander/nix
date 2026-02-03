{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nx.server.nextcloud;
in
{
  options.nx.server.nextcloud = {
    enable = mkEnableOption "Nextcloud server";
  };

  config = mkIf cfg.enable {
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
      settings = {
        maintenance_window_start = 2; # 02:00
        default_phone_region = "de";
        overwriteProtocol = "https";
        trusted_domains = [ "cloud.schererleander.de" ];
        logtimezone = config.time.timeZone;
        log_type = "file";
        enabledPreviewProviders = [
          # Default
          "OC\\Preview\\BMP"
          "OC\\Preview\\GIF"
          "OC\\Preview\\JPEG"
          "OC\\Preview\\Krita"
          "OC\\Preview\\MarkDown"
          "OC\\Preview\\OpenDocument"
          "OC\\Preview\\PNG"
          "OC\\Preview\\TXT"
          "OC\\Preview\\XBitmap"
          # Non default
          #"OC\\Preview\\Font"
          "OC\\Preview\\HEIC"
          #"OC\\Preview\\MP3"
          #"OC\\Preview\\Movie"
          #"OC\\Preview\\PDF"
          #"OC\\Preview\\SVG"
        ];
      };
      phpOptions."opcache.interned_strings_buffer" = "64";
    };

    services.nginx.virtualHosts = mkIf ((config.nx.server.nginx or { }).enable or false) {
      "cloud.schererleander.de" = {
        forceSSL = true;
        sslCertificate = config.nx.server.nginx.sslCertificate;
        sslCertificateKey = config.nx.server.nginx.sslCertificateKey;
      };
    };

    services.borgbackup.jobs.nextcloud = {
      paths = [
        "/var/lib/nextcloud"
        "/var/lib/backup/nextcloud/db"
      ];
      repo = config.sops.secrets."borg_repo".path;
      encryption.mode = "none";
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
      bantime = "86400";
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

