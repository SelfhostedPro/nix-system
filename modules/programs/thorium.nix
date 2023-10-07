# WiP
{
  lib,
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; let
    thorium-browser = mkChromiumDerivation {
      name = "thorium";
      packageName = "thorium-browser";




      version = "1.0.4";
      sha256 = "09g0ln247scv8mj40gxhkij0li62v0rjm2bsgmvl953aj7g3dlh1";
      vendorSha256 = "07pzqvf9lwgc1fadmyam5hn7arlvzrjsplls445738jpn61854gg";
    };
  in [];
}
