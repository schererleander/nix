{
  flake.modules.nixos.git =
    {
      config,
      lib,
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
        description = "Mirror GitHub repositories for schererleander";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        script = ''
          set -euo pipefail

          echo "Fetching repository list for schererleander..."

          cd /var/lib/git-server

          DEFAULT_DESC="Unnamed repository; edit this file 'description' to name the repository."

          ${pkgs.curl}/bin/curl -s "https://api.github.com/users/schererleander/repos?per_page=100" \
            | ${pkgs.jq}/bin/jq -r --arg def "$DEFAULT_DESC" \
              '.[] | "\(.clone_url)\t\(.description | if . == null or . == "" then $def else . end | gsub("[\n\t]"; " "))"' \
            | while IFS=$'\t' read -r REPO_URL REPO_DESC; do
            
            REPO_NAME=$(basename -s .git "$REPO_URL")
            TARGET_DIR="$REPO_NAME.git"

            if [ ! -d "$TARGET_DIR" ]; then
              echo "Cloning $REPO_NAME..."
              ${pkgs.git}/bin/git clone --mirror "$REPO_URL" "$TARGET_DIR"
            else
              echo "Updating $REPO_NAME..."
              ${pkgs.git}/bin/git -C "$TARGET_DIR" fetch --prune origin
            fi
            
            echo "$REPO_DESC" > "$TARGET_DIR/description"
          done
        '';

        serviceConfig = {
          Type = "oneshot";
          User = "git";
          Group = "git";

          # Security hardening
          CapabilityBoundingSet = "";
          ProtectSystem = "strict";
          ProtectHome = true;
          ReadWritePaths = "/var/lib/git-server";
        };
      };

      systemd.timers.github-mirror = {
        description = "Timer to mirror GitHub repositories for schererleander";
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
        repo = "ssh://e5e496ni@e5e496ni.repo.borgbase.com/./repo";
        encryption.mode = "none";
        environment = {
          BORG_RSH = "ssh -i ${
            config.sops.secrets."borgbase_ssh_key".path
          } -o StrictHostKeyChecking=accept-new";
        };
        compression = "auto,lzma";
        startAt = "daily";
      };
    };
}
