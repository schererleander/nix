{
  config,
  lib,
  username,
  ...
}:

{
  options.nx.programs.zed-editor.enable = lib.mkEnableOption "Enable and setup zed editor";
  config = lib.mkIf config.nx.programs.zed-editor.enable {
    home-manager.users."${username}" = {
      programs.zed-editor = {
        enable = true;
        extensions = [
          "nix"
        ];
        userSettings = {
          telemetry = {
            metrics = false;
          };
        };
      };
    };
  };
}
