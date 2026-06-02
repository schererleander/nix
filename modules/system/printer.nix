{
  flake.modules.nixos.printer =
    { pkgs, ... }:
    {
      services.printing = {
        enable = true;
        drivers = [ pkgs.brlaser ];
        cups-pdf.enable = true;
      };
      services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
    };
}
