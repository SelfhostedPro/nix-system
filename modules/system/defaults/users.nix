{vars, ...}: {
  users.users.${vars.user.name} = {
    isNormalUser = true;
    extraGroups = ["wheel" "video" "input" "audio" "camera" "networkmanager" "lp" "kvm" "libvirtd" "docker"];
  };
}
