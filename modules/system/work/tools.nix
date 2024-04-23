{pkgs, ...}: let
  terraform_1-4-6 = pkgs.mkTerraform {
    version = "1.4.6";
    hash = "sha256-V5sI8xmGASBZrPFtsnnfMEHapjz4BH3hvl0+DGjUSxQ=";
    vendorHash = "sha256-OW/aS6aBoHABxfdjDxMJEdHwLuHHtPR2YVW4l0sHPjE=";
  };
in {
  environment.systemPackages = with pkgs; [
    awscli2
    aws-vault
    terraform_1-4-6
    nodejs_18
    kubernetes-helm
    kubernetes
    sqlite-web
    sqlitebrowser
    sqlite
    dbeaver
  ];
}
