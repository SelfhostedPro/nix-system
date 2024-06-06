{ lib
, fetchFromGitHub
, pkgs
}:

pkgs.orca-slicer.overrideAttrs (
  finalAttrs: previousAttrs: {
    version = "2.1.0-beta";
    pname = "orca-slicer-beta";
    src = fetchFromGitHub {
      owner = "SoftFever";
      repo = "OrcaSlicer";
      rev = "v${finalAttrs.version}";
      hash = "sha256-YlLDUH3ODIfax5QwnsVJi1JjZ9WtxP3ssqRP1C4d4bw=";
    };

    # # needed to prevent collisions between the LICENSE.txt files of
    # # bambu-studio and orca-slicer.
    # postInstall = ''
    #   mv $out/LICENSE.txt $out/share/OrcaSlicer/LICENSE.txt
    # '';
    meta = with lib; {
      description = "G-code generator for 3D printers (Bambu, Prusa, Voron, VzBot, RatRig, Creality, etc)";
      homepage = "https://github.com/SoftFever/OrcaSlicer";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [
        zhaofengli
        ovlach
        pinpox
      ];
      mainProgram = "orca-slicer-beta";
      platforms = platforms.linux;
    };
  }
)
