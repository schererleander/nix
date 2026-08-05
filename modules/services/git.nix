{
  flake.modules.nixos.git =
    {
      config,
      pkgs,
      ...
    }:
    {
      users.users.git = {
        isSystemUser = true;
        group = "git";
        home = "/var/lib/git-server";
        createHome = true;
        shell = "${pkgs.git}/bin/git-shell";
      };
      users.groups.git = { };

      systemd.services.github-mirror = {
        description = "Mirror GitHub repositories";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        script = ''
          set -euo pipefail

          cd /var/lib/git-server

          API_DATA="$(${pkgs.coreutils}/bin/mktemp)"
          REPO_NAMES="$(${pkgs.coreutils}/bin/mktemp)"
          trap '${pkgs.coreutils}/bin/rm -f "$API_DATA" "$REPO_NAMES"' EXIT

          ${pkgs.curl}/bin/curl -fsS \
            "https://api.github.com/users/schererleander/repos?per_page=100" \
            > "$API_DATA"

          ${pkgs.jq}/bin/jq -r '.[].name' "$API_DATA" > "$REPO_NAMES"

          ${pkgs.jq}/bin/jq -r '
            .[]
            | [
                .clone_url,
                (.description // "Unnamed repository")
              ]
            | @tsv
          ' "$API_DATA" |
          while IFS=$'\t' read -r REPO_URL REPO_DESC; do
            REPO_NAME="$(${pkgs.coreutils}/bin/basename -s .git "$REPO_URL")"
            TARGET_DIR="$REPO_NAME.git"

            if [ -d "$TARGET_DIR" ]; then
              echo "Updating $REPO_NAME"
              ${pkgs.git}/bin/git -C "$TARGET_DIR" fetch --prune origin
            else
              echo "Cloning $REPO_NAME"
              ${pkgs.git}/bin/git clone --mirror "$REPO_URL" "$TARGET_DIR"
            fi

            echo "$REPO_DESC" > "$TARGET_DIR/description"
          done

          for TARGET_DIR in *.git; do
            [ -d "$TARGET_DIR" ] || continue

            REPO_NAME="''${TARGET_DIR%.git}"

            if ! ${pkgs.gnugrep}/bin/grep -Fxq "$REPO_NAME" "$REPO_NAMES"; then
              echo "Deleting $REPO_NAME"
              ${pkgs.coreutils}/bin/rm -rf -- "$TARGET_DIR"
            fi
          done
        '';
        serviceConfig = {
          Type = "oneshot";
          User = "git";
          Group = "git";

          CapabilityBoundingSet = "";
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
          ReadWritePaths = "/var/lib/git-server";
        };
      };

      systemd.timers.github-mirror = {
        description = "Timer to mirror GitHub repositories";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "hourly";
          Persistent = true;
        };
      };

      services.borgbackup.jobs.git = {
        paths = [
          "/var/lib/git-server"
        ];
        repo = "$BORG_REPO";
        encryption.mode = "none";
        environment = {
          BORG_RSH = "ssh -i ${
            config.sops.secrets."borgbase_ssh_key".path
          } -o StrictHostKeyChecking=accept-new";
        };
        extraCreateArgs = [
          "--info"
          "--stats"
        ];
        compression = "auto,lzma";
        startAt = "daily";
        preHook = ''
          set -euo pipefail
          export BORG_REPO="$(cat ${config.sops.secrets."borg_git_repo".path})"
        '';
      };

      systemd.services."borgbackup-job-git".unitConfig.OnFailure = [ "notify-backup-failure@%n.service" ];
    };
}
