# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{ pkgs ? import <nixpkgs> { } }: rec {
  orca-slicer-beta = pkgs.callPackage ./orca-beta.nix {};
  # thorium = pkgs.callPackage ./thorium.nix {};
}
