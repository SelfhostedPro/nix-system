{ lib
, pkgs
,
}:

pkgs.orca-slicer.overrideAttrs (
  finalAttrs: previousAttrs: {
    version = "2.1.0-beta";

    src = pkgs.fetchFromGitHub {
      owner = "SoftFever";
      repo = "OrcaSlicer";
      rev = "v${finalAttrs.version}";
      hash = "sha256-fR1tUNe79X5WY6lfUvrQ2HUbQ9AY+/03PL4U2GlWHL4=";
    };

    patches = [
      # Fix for webkitgtk linking
      ./0001-not-for-upstream-CMakeLists-Link-against-webkit2gtk-.patch
      # Fix build with cgal-5.6.1+
      ./meshboolean-const.patch
    ];

    # Disable compiler warnings that clutter the build log.
    # It seems to be a known issue for Eigen:
    # http://eigen.tuxfamily.org/bz/show_bug.cgi?id=1221
    NIX_CFLAGS_COMPILE = "-Wno-ignored-attributes -Wno-unused-function -Wno-error -Wno-sign-compare";

    cmakeFlags = [
      "-DSLIC3R_STATIC=0"
      "-DSLIC3R_FHS=1"
      "-DSLIC3R_GTK=3"
      "-Wno-error"
      "-Wno-sign-compare"

      # BambuStudio-specific
      "-DBBL_RELEASE_TO_PUBLIC=1"
      "-DBBL_INTERNAL_TESTING=0"
      "-DDEP_WX_GTK3=ON"
      "-DSLIC3R_BUILD_TESTS=0"
      "-DCMAKE_CXX_FLAGS=-DBOOST_LOG_DYN_LINK"
    ];

    buildInputs = [
      pkgs.opencv
    ] ++ previousAttrs.buildInputs;
  }
)
