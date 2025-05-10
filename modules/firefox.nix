{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.firefox;
in {
  options.firefox.enable = lib.mkEnableOption "Setup firefox";

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      profiles.default = {
        extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
          ublock-origin
          istilldontcareaboutcookies
          sponsorblock
          vimium-c
          adaptive-tab-bar-colour
        ];

        search.engines = {
          nix-packages = {
            name = "Nix Packages";
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };

          nixos-wiki = {
            name = "NixOS Wiki";
            urls = [{ template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; }];
            iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
            definedAliases = [ "@nw" ];
          };

          startpage = {
            name = "Startpage";
            urls = [{
              template = "https://www.startpage.com/sp/search?query={searchTerms}";
            }];
            icon = "https://www.startpage.com/favicon.ico";
            definedAliases = [ "@s" ];
          };

          bing.metaData.hidden = true;
          google.metaData.alias = "@g";
        };

        search.default = "startpage";

        settings = {
          "extensions.autoDisableScopes" = 0;
        };

        userChrome = ''
          /* Hide Back, Forward, Reload, Stop, All Tabs, Firefox View buttons */
          #back-button,
          #forward-button,
          #reload-button,
          #stop-button,
          #alltabs-button,
          #firefox-view-button {
            display: none !important;
          }

          #tabbrowser-tabs {
            border-inline: none !important;
          }

          .titlebar-buttonbox-container {
            display: none;
          }
        '';
      };

      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        DisplayBookmarksToolbar = "never";

        Preferences = {
          # Set homepage
          "browser.startup.homepage" = "about:blank";

          # Disable tips
          "browser.snippets.enabled" = false;

          # Disable onboarding
          "browser.startup.homepage_override.mstone" = "ignore";
          "startup.homepage_override_url" = "";
          "startup.homepage_welcome_url" = "";
          "startup.homepage_welcome_url.additional" = "";
          "browser.messaging-system.whatsNewPanel.enabled" = false;

          # Remove Firefox View
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSearch" = false;
          "browser.newtabpage.activity-stream.showTopSites" = false;
          "browser.newtabpage.activity-stream.showHighlights" = false;
          "browser.newtabpage.enabled" = false;
          "browser.toolbars.bookmarks.visibility" = "never";

          # Privacy settings
          "privacy.firstparty.isolate" = true;  # Isolate cookies per site
          "privacy.resistFingerprinting" = true;

          # Enable HTTPS-Only Mode
          "dom.security.https_only_mode" = true;
          "dom.security.https_only_mode_ever_enabled" = true;

          # More Privacy settings
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "privacy.partition.network_state.ocsp_cache" = true;

          # Disable all sorts of telemetry
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.ping-centre.telemetry" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.hybridContent.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.updatePing.enabled" = false;

          # Disable Firefox 'experiments'
          "experiments.activeExperiment" = false;
          "experiments.enabled" = false;
          "experiments.supported" = false;
          "network.allow-experiments" = false;

          # Disable Pocket Integration
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
          "extensions.pocket.enabled" = false;
          "extensions.pocket.api" = "";
          "extensions.pocket.oAuthConsumerKey" = "";
          "extensions.pocket.showHome" = false;
          "extensions.pocket.site" = "";

          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
      };
    };
  };
}