#            "##" = Ryans Configs, Use in baremetal boot
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

  {
  imports = [
     (modulesPath + "/profiles/qemu-guest.nix")
    #(modulesPath + "/installer/scan/not-detected.nix")
  ];
  # Use the EFI boot loader.
  boot.loader.efi.canTouchEfiVariables = true;
  # depending on how you configured your disk mounts, change this to /boot or /boot/efi.
  boot.loader.efi.efiSysMountPoint = "/boot";
  ##boot.loader.systemd-boot.enable = true;

  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk"
  #"xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"
  ];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"]; # kvm virtualization support
  boot.extraModprobeConfig = "options kvm_intel nested=1"; # for intel cpu
  boot.kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"];
  boot.extraModulePackages = [];
  # clear /tmp on boot to get a stateless /tmp directory.
  boot.tmp.cleanOnBoot = true;

  # Enable binfmt emulation of aarch64-linux, this is required for cross compilation.
  boot.binfmt.emulatedSystems = ["aarch64-linux" "riscv64-linux"];
  # supported file systems, so we can mount any removable disks with these filesystems
  boot.supportedFilesystems = [
    "ext4"
    "btrfs"
    "xfs"
    "ntfs"
    "fat"
    "vfat"
    "exfat"
  ];



  ###############################################RYANS LUKS ENCRYPT##############################
  ##boot.initrd = {
    # unlocked luks devices via a keyfile or prompt a passphrase.
    ##luks.devices."crypted-nixos" = {
      # NOTE: DO NOT use device name here(like /dev/sda, /dev/nvme0n1p2, etc), use UUID instead.
      # https://github.com/ryan4yin/nix-config/issues/43
      ##device = "/dev/disk/by-uuid/a21ca82a-9ee6-4e5c-9d3f-a93e84e4e0f4";
      # the keyfile(or device partition) that should be used as the decryption key for the encrypted device.
      # if not specified, you will be prompted for a passphrase instead. Use Below
      #keyFile = "/root-part.key";

      # whether to allow TRIM requests to the underlying device.
      # it's less secure, but faster.
      ##allowDiscards = true;
      # Whether to bypass dm-crypt’s internal read and write workqueues.
      # Enabling this should improve performance on SSDs;
      # https://wiki.archlinux.org/index.php/Dm-crypt/Specialties#Disable_workqueue_for_increased_solid_state_drive_(SSD)_performance
      ##bypassWorkqueues = true;
    ##};
  ##};

  fileSystems."/" = {
      device = "/dev/disk/by-uuid/6920fbab-939f-4067-82aa-4b461b477157";
      fsType = "ext4";
   ## device = "/dev/disk/by-uuid/1167076c-dee1-486c-83c1-4b1af37555cd";
   ## fsType = "btrfs";
    # btrfs's top-level subvolume, internally has an id 5
    # we can access all other subvolumes from this subvolume.
  };



  # mount swap subvolume in readonly mode.
  ##fileSystems."/swap" = {
    ##device = "/dev/disk/by-uuid/1167076c-dee1-486c-83c1-4b1af37555cd";
    ##fsType = "btrfs";
    ##options = ["subvol=@swap" "ro"];
  ##};

  # remount swapfile in read-write mode
  ##fileSystems."/swap/swapfile" = {
    # the swapfile is located in /swap subvolume, so we need to mount /swap first.
    ##depends = ["/swap"];

    ##device = "/swap/swapfile";
    ##fsType = "none";
    ##options = ["bind" "rw"];
  ##};


  swapDevices = [
    ##{device = "/swap/swapfile";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
