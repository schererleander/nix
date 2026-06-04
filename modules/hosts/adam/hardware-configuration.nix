{
  flake.modules.nixos.adam =
    {
      config,
      lib,
      ...
    }:

    {
      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];

      fileSystems."/" = {
        device = "/dev/mapper/luks-2e381c8d-394c-4027-953a-4dee645bdcc0";
        fsType = "ext4";
      };

      boot.initrd.luks.devices."luks-2e381c8d-394c-4027-953a-4dee645bdcc0".device =
        "/dev/disk/by-uuid/2e381c8d-394c-4027-953a-4dee645bdcc0";

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/A31A-E5AD";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      swapDevices = [
        { device = "/dev/mapper/luks-c8c2ebcd-5e0d-4523-8cf6-b7fdf67c14a4"; }
      ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };

}
