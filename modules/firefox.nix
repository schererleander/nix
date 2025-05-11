{ config, lib, pkgs, inputs, ... }:

{
  options.firefox.enable = lib.mkEnableOption "Setup firefox";
  config = lib.mkIf config.firefox.enable {
    programs.firefox = {
      enable = true;
      profiles.default = {
        extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
          ublock-origin
          istilldontcareaboutcookies
          sponsorblock
          vimium-c
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

          .titlebar-buttonbox-container {
            display: none;
          }

          #tabbrowser-tabs {
            border-inline: none !important;
          }

          /* Transparent background tabs (above url bar) */
          #navigator-toolbox {
            -moz-appearance: -moz-vibrant-titlebar !important;
            background: rgba(0, 0, 0, 0.8) !important;
          }

          /* Transparent background (behind url bar) */
          #nav-bar {
              background: none !important;
              box-shadow: none !important;
              border-top: 0px !important;
          }

          .tab-background[selected="true"] {
            background-color: #393e43 !important;
            background-image: none !important;
          }

          .tab-background {
            background-color: var(--background) !important;
            color: var(--foreground) !important;
            box-shadow: none !important;;
          }
 
          .tab-background[selected] {
            background-color: rgba(0, 0, 0, 0.30) !important;
            color: var(--foreground) !important;
            box-shadow: none !important;
          }

          /* Needed for # transparency in general */
          :root {
            --tabpanel-background-color: transparent !important; 
            --chrome-content-separator-color: transparent !important;
            --toolbar-bgcolor: rgba(0, 0, 0, 0.9) !important;
            --newtab-background-color: rgba(0, 0, 0, 0.9) !important;
            --newtab-background-color-secondary: transparent !important;
            --toolbar-field-background-color: rgba(120, 120, 120, 0.10) !important;
          }
        '';
        userContent = ''
          @-moz-document url-prefix("about:"), url("about:home") {
            /* Transparent about:settings about:config about:policies */
            :root {
              background: rgba(0, 0, 0, 0.0) !important;
            }
          }

          /* Transparent about:home */
          * {
              --newtab-background-color: transparent !important;
              --newtab-background-color-secondary: transparent !important;
          }

          /* Transparent elements in about:* */
          * {
            --in-content-page-background: transparent !important;
            --background-color-box: rgba(0, 0, 0, 0.5) !important;
          }
        '';
      };

      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        PasswordManagerEnabled = false;
        OfferToSaveLogins = false;
        DisablePocket = true;
        DisplayBookmarksToolbar = "never";
        NoDefaultBookmarks = true;

        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };

        EncryptedMediaExtensions = {
          Enabled = true;
          Locked = true;
        };

        FirefoxHome = {
          Search = true;
          TopSites = true;
          SponsoredTopSites = false;
          Highlights = true;
          Pocket = false;
          SponsoredPocket = false;
          Snippets = false;
          Locked = true;
        };

        UserMessaging = {
          ExtensionRecommendations = false;
          FeatureRecommendations = false;
          Locked = true;
          MoreFromMozilla = false;
          SkipOnboarding = true;
          UrlbarInterventions = false;
          WhatsNew = false;
        };

        "3rdparty".Extensions = {
          "uBlock0@raymondhill.net".adminSettings = {
            userSettings = {
              uiTheme = "dark";
              uiAccentCustom = true;
              uiAccentCustom0 = "#2C2C2C";
              cloudStorageEnabled = false;
              contextMenuEnabled = false;
            };
            # Block annoying login with google banner
            userFilters = ''
                ||accounts.google.com/gsi/*
            '';
          };
        };
        
        Preferences = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.toolbars.bookmarks.visibility" = "never";

          # Hide pip controls
          "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
          
          # Set homepage
          "browser.startup.homepage" = "about:blank";
          "browser.newtab.url" = "about:blank";
          "browser.newtabpage.enabled" = false;

          # transparency
          "browser.tabs.allow_transparent_browser" = true;
          "gfx.webrender.all" = true;

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
        };
      };
    };
  };
}