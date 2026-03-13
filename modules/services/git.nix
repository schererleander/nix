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
    };
}
