{ config, pkgs, ... }: {
  homebrew = {
    brews = [
      "aws-vault"
      "awscli"
      "terraform"
    ];
  };
}
