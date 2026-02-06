{
  flake.modules.nixos.sachiel = {
    boot.loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/4E07-7ABB";
      fsType = "vfat";
    };
    boot.initrd.availableKernelModules = [
      "ata_piix"
      "uhci_hcd"
      "xen_blkfront"
      "vmw_pvscsi"
      "virtio_net"
      "virtio_pci"
      "virtio_mmio"
      "virtio_blk"
      "virtio_scsi"
      "9p"
      "9pnet_virtio"
    ];
    boot.initrd.kernelModules = [
      "nvme"
      "virtio_balloon"
      "virtio_console"
      "virtio_rng"
      "virtio_gpu"
    ];
    fileSystems."/" = {
      device = "/dev/vda1";
      fsType = "ext4";
    };
  };
}
