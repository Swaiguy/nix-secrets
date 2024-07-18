{lib, ...}: {
  boot.loader.grub.enable = true;
  # for power management
  services = {
    power-profiles-daemon = {
      enable = true;
    };
    upower.enable = true;
  };
}
