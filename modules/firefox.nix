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
          startpage-private-search
          adaptive-tab-bar-colour
        ];
        settings = {
          "extensions.autoDisableScopes" = 0;
        };
      };

      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value= true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        DisplayBookmarksToolbar = "never";

        Preferences = {
          # Remove Firefox View
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSearch" = false;
          "browser.newtabpage.activity-stream.showTopSites" = false;
          "browser.newtabpage.activity-stream.showHighlights" = false;
          "browser.newtabpage.enabled" = false;
          "browser.toolbars.bookmarks.visibility" = "never";

          # privacy settings
          "privacy.firstparty.isolate" = true;  # Isolate cookies per site
          "privacy.resistFingerprinting" = true;

          # Enable HTTPS-Only Mode
          "dom.security.https_only_mode" = true;
          "dom.security.https_only_mode_ever_enabled" = true;

          # Privacy settings
          #"privacy.donottrackheader.enabled" = true;
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