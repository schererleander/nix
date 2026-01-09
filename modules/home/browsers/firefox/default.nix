{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let

  cfg = config.nx.browsers.firefox;
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    optionalString
    optionalAttrs
    ;
in
{

  options.nx.browsers.firefox = {
    enable = mkEnableOption "mozilla firefox";
    blockGoogle = mkOption {
      description = "blocks google banner and other";
      type = types.bool;
      default = true;
    };
    transparent = mkOption {
      description = "make firefox transparent";
      type = types.bool;
      default = false;
    };
    cleanHome = mkOption {
      description = "clean up firefox home";
      type = types.bool;
      default = true;
    };
    hideRecommendations = mkOption {
      description = "hide firefox recommendations";
      type = types.bool;
      default = true;
    };
    disablePasswordManager = mkOption {
      description = "disable built-in browser password manager";
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      profiles.default = {
        extensions = {
          packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
            ublock-origin
            istilldontcareaboutcookies
            sponsorblock
            decentraleyes
            vimium-c
          ];

          force = true;

          settings."uBlock0@raymondhill.net".settings = {
            UserMessaging = {
              uiTheme = "dark";
              uiAccentCustom = true;
              uiAccentCustom0 = "#2C2C2C";
              cloudStorageEnabled = false;
              contextMenuEnabled = false;
            };
            # Block annoying login with google banner
            userFilters = optionalString cfg.blockGoogle ''
              ||accounts.google.com/gsi/*
            '';
          };
        };

        search = {
          default = "DuckDuckGo";
          engines = {
            nix-packages = {
              name = "Nix Packages";
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];

              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };

            nixos-wiki = {
              name = "NixOS Wiki";
              urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
              iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
              definedAliases = [ "@nw" ];
            };

            bing.metaData.hidden = true;
            google.metaData.alias = "@g";
          };
          force = true;
        };

        userChrome = optionalString cfg.transparent ''
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

          /* Needed for transparency in general */
          :root {
            --tabpanel-background-color: transparent !important; 
            --chrome-content-separator-color: transparent !important;
            --toolbar-bgcolor: rgba(0, 0, 0, 0.9) !important;
            --newtab-background-color: rgba(0, 0, 0, 0.9) !important;
            --newtab-background-color-secondary: transparent !important;
            --toolbar-field-background-color: rgba(120, 120, 120, 0.10) !important;
          }
        '';
        userContent = optionalString cfg.transparent ''
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
        PasswordManagerEnabled = !cfg.disablePasswordManager;
        OfferToSaveLogins = !cfg.disablePasswordManager;
        DisplayBookmarksToolbar = "never";
        NoDefaultBookmarks = true;

        Homepage = optionalAttrs cfg.cleanHome {
          URL = "about:blank";
          Locked = true;
          StartPage = "homepage";
        };

        NewTabPage = !cfg.cleanHome;

        PictureInPicture = {
          Enabled = false;
        };

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
          SponsoredTopSites = !cfg.cleanHome;
          Highlights = true;
          Pocket = !cfg.cleanHome;
          SponsoredPocket = !cfg.cleanHome;
          Locked = true;
        };

        UserMessaging = {
          ExtensionRecommendations = !cfg.hideRecommendations;
          FeatureRecommendations = !cfg.hideRecommendations;
          Locked = true;
          MoreFromMozilla = !cfg.hideRecommendations;
          SkipOnboarding = true;
          UrlbarInterventions = !cfg.hideRecommendations;
        };

        Preferences = {
          # Disable fullscreen notification
          "full-screen-api.warning.timeout" = "0";

          # Disable annoying translation popup
          "browser.translations.automaticallyPopup" = false;

          # Enable all extensions automatically
          "extensions.autoDisableScopes" = 0;

          # Hide ctr-tab tab preview menu
          "browser.ctrlTab.sortByRecentlyUsed" = false;
        }
        // optionalAttrs cfg.transparent {
          # transparency
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.tabs.allow_transparent_browser" = true;
          "gfx.webrender.all" = true;
        };
      };
    };
  };
}
