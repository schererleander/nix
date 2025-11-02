{
  config,
  username,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options.nx.programs.firefox.enable = lib.mkEnableOption "Setup firefox";
  config = lib.mkIf config.nx.programs.firefox.enable {
    home-manager.users.${username} = {
      programs.firefox = {
        enable = true;
        profiles.default = {
          extensions = {
            packages = with inputs.firefox-addons.packages.${pkgs.system}; [
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
              userFilters = ''
                ||accounts.google.com/gsi/*
              '';
            };
          };

          search.engines = {
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

            startpage = {
              name = "Startpage";
              urls = [
                {
                  template = "https://www.startpage.com/sp/search?query={searchTerms}";
                }
              ];
              icon = "https://www.startpage.com/favicon.ico";
              definedAliases = [ "@s" ];
            };

            bing.metaData.hidden = true;
            google.metaData.alias = "@g";
          };

          search.default = "startpage";

          settings = {
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
          #PasswordManagerEnabled = false;
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

          Preferences = {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "browser.toolbars.bookmarks.visibility" = "never";

            # Disable fullscreen notification
            "full-screen-api.warning.timeout" = "0";

            # Disable annoying translation popup
            "browser.translations.automaticallyPopup" = false;

            # Enable all extensions automatically
            "extensions.autoDisableScopes" = 0;

            # Hide ctr-tab tab preview menu
            "browser.ctrlTab.sortByRecentlyUsed" = false;

            # Hide pip controls
            "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;

            # Set homepage
            "browser.startup.homepage" = "about:blank";
            "browser.newtab.url" = "about:blank";
            "browser.newtabpage.enabled" = false;

            # transparency
            "browser.tabs.allow_transparent_browser" = true;
            "gfx.webrender.all" = true;
          };
        };
      };
    };
  };
}