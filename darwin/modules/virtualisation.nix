{
  config,
  pkgs,
  ...
}: {
  # Install Packages
  homebrew = {
    taps = [
      "jeffreywildman/homebrew-virt-manager"
    ];
    brews = [
      "qemu"
      "virt-viewer"
      "virt-manager"
      "glib-networking"
      {
        name = "libvirt";
        start_service = true;
        restart_service = "changed";
      }
    ];
  };
  # Startup
  # virt-manager -c "qemu:///session" --no-fork
  # https://github.com/jeffreywildman/homebrew-virt-manager/issues/168
}
