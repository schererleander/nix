{ inputs, ... }:

let
  lib = inputs.nixpkgs.lib;
  isDarwin = s: lib.strings.hasSuffix "-darwin" s;
in
{
  mkUser =
    {
      username,
      homeDirectory ? null,
      useHomeManager ? true,
      extraHomeModules ? [ ],
    }:
    {
      config,
      pkgs,
      lib,
      system,
      inputs,
      ...
    }:
    let
      inherit (lib)
        mkOption
        types
        mkIf
        mkMerge
        optional
        optionals
        ;

      darwinHost = isDarwin system;
      defaultHome = if darwinHost then "/Users/${username}" else "/home/${username}";
      home = if homeDirectory != null then homeDirectory else defaultHome;

      anyDesktopEnabled =
        (config.nx.desktop.kde.enable or false)
        || (config.nx.desktop.hyprland.enable or false)
        || (config.nx.desktop.gnome.enable or false)
        || (config.nx.desktop.cinnamon.enable or false)
        || (config.nx.desktop.sway.enable or false)
        || (config.nx.desktop.labwc.enable or false);

      cfg = config.nx.user.${username};

      shellPkg = if (cfg.nx.terminal.defaultShell or "bash") == "zsh" then pkgs.zsh else pkgs.bash;
    in
    {
      options.nx.user.${username} = mkOption {
        description = "User configuration for ${username}";
        type = types.submodule {
          freeformType = types.attrsOf types.anything;
          options = {
            stateVersion = mkOption {
              type = types.str;
              description = "home.stateVersion for this user";
            };

            packages = mkOption {
              type = types.listOf types.package;
              default = [ ];
              description = "Extra packages for this user";
            };

            shellAliases = mkOption {
              type = types.attrsOf types.str;
              default = { };
              description = "Shell aliases";
            };

            sessionVariables = mkOption {
              type = types.attrsOf types.str;
              default = { };
              description = "Session environment variables";
            };

            nx = mkOption {
              type = types.attrsOf types.anything;
              default = { };
              description = "User module options (proxied to home-manager's nx.*)";
            };
          };
        };
        default = { };
      };

      config = mkMerge [
        (mkIf (!darwinHost) {
          users.users.${username} = {
            isNormalUser = true;
            home = home;
            shell = shellPkg;
            ignoreShellProgramCheck = true;
            extraGroups =
              [
                "wheel"
              ]
              ++ optional (config.networking.networkmanager.enable or false) "networkmanager"
              ++ optionals anyDesktopEnabled [
                "video"
                "input"
              ]
              ++ optional (config.nx.services.audio.enable or false) "audio"
              ++ optional (config.nx.printer.enable or false) "lp";
          };
        })

        (mkIf darwinHost {
          users.users.${username}.home = home;
        })

        (mkIf useHomeManager {
          home-manager.extraSpecialArgs = { inherit inputs; };

          home-manager.users.${username} = {
            home.username = username;
            home.homeDirectory = home;
            home.stateVersion = cfg.stateVersion;
            home.packages = cfg.packages;
            home.sessionVariables = cfg.sessionVariables;

            programs.home-manager.enable = true;

            programs.zsh.shellAliases = mkIf (cfg.nx.terminal.defaultShell == "zsh") cfg.shellAliases;
            programs.bash.shellAliases = mkIf (cfg.nx.terminal.defaultShell == "bash") cfg.shellAliases;

            imports = [ ../modules/users ] ++ extraHomeModules;

            nx = cfg.nx;
          };
        })
      ];
    };

  mkSystem =
    {
      host,
      username,
      system,
      overlays ? [ ],
      extraModules ? [ ],
      extraSpecialArgs ? { },
      useHomeManager ? true,
      extraHomeModules ? [ ],
    }:
    let
      darwinHost = isDarwin system;
      builder =
        if darwinHost then inputs.nix-darwin.lib.darwinSystem else inputs.nixpkgs.lib.nixosSystem;
      hostDir = ../hosts/${host};
      hostCfg = hostDir + /configuration.nix;

      self = import ./. { inherit inputs; };

      nixpkgsModule = {
        nixpkgs.overlays = overlays;
        nixpkgs.config.allowUnfree = true;

        nix.settings.experimental-features = [
          "nix-command"
          "flakes"
        ];
      };

      modules =
        [
          hostCfg
          nixpkgsModule
        ]
        ++ (lib.optional (!darwinHost) ../modules/hosts)
        ++ (lib.optional useHomeManager (
          if darwinHost then
            inputs.home-manager.darwinModules.home-manager
          else
            inputs.home-manager.nixosModules.home-manager
        ))
        ++ (lib.optional useHomeManager (self.mkUser {
          inherit
            username
            useHomeManager
            extraHomeModules
            ;
        }))
        ++ extraModules;
    in
    builder {
      system = system;
      specialArgs = (
        {
          inherit
            inputs
            system
            host
            username
            useHomeManager
            ;
        }
        // extraSpecialArgs
      );
      modules = modules;
    };
}
