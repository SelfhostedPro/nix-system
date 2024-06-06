{ stdenv
, lib
, pkgs
}:
let
  opencascade-occt = pkgs.opencascade-occt_7_6;
  wxGTK31' = pkgs.wxGTK31.overrideAttrs (old: {
    configureFlags = old.configureFlags ++ [
      # Disable noisy debug dialogs
      "--enable-debug=no"
    ];
  });
  openvdb_tbb_2021_8 = pkgs.openvdb.overrideAttrs (old: rec {
    buildInputs = [
      pkgs.openexr
      pkgs.boost179
      pkgs.tbb_2021_11
      pkgs.jemalloc
      pkgs.c-blosc
      pkgs.ilmbase
    ];
  });
in
stdenv.mkDerivation rec {
  pname = "orca-slicer";
  version = "2.1.0-beta";

  src = pkgs.fetchFromGitHub {
    owner = "SoftFever";
    repo = "OrcaSlicer";
    rev = "v${version}";
    hash = "sha256-fR1tUNe79X5WY6lfUvrQ2HUbQ9AY+/03PL4U2GlWHL4=";
  };

  nativeBuildInputs = [
    pkgs.cmake
    pkgs.pkg-config
    pkgs.wrapGAppsHook3
  ];

  buildInputs = [
    pkgs.binutils
    pkgs.boost179
    pkgs.cereal
    pkgs.cgal_5
    pkgs.curl
    pkgs.dbus
    pkgs.eigen
    pkgs.expat
    pkgs.gcc-unwrapped
    pkgs.glew
    pkgs.glfw
    pkgs.glib
    pkgs.glib-networking
    pkgs.gmp
    pkgs.gst_all_1.gstreamer
    pkgs.gst_all_1.gst-plugins-base
    pkgs.gst_all_1.gst-plugins-bad
    pkgs.gst_all_1.gst-plugins-good
    pkgs.gtk3
    pkgs.hicolor-icon-theme
    pkgs.ilmbase
    pkgs.libpng
    pkgs.mesa.osmesa
    pkgs.mpfr
    pkgs.nlopt
    opencascade-occt
    openvdb_tbb_2021_8
    pkgs.pcre
    pkgs.tbb_2021_11
    pkgs.webkitgtk
    wxGTK31'
    pkgs.xorg.libX11
  ] ++ [ pkgs.systemd ] ++ checkInputs;

  patches = [
    # Fix for webkitgtk linking
    ./orca.patch
    # Fix build with cgal-5.6.1+
    # ./meshboolean-const.patch
  ];

  doCheck = true;
  checkInputs = [ pkgs.gtest ];

  separateDebugInfo = true;

  # The build system uses custom logic - defined in
  # cmake/modules/FindNLopt.cmake in the package source - for finding the nlopt
  # library, which doesn't pick up the package in the nix store.  We
  # additionally need to set the path via the NLOPT environment variable.
  NLOPT = pkgs.nlopt;

  # Disable compiler warnings that clutter the build log.
  # It seems to be a known issue for Eigen:
  # http://eigen.tuxfamily.org/bz/show_bug.cgi?id=1221
  NIX_CFLAGS_COMPILE = "-Wno-ignored-attributes";

  # prusa-slicer uses dlopen on `libudev.so` at runtime
  NIX_LDFLAGS = "-ludev";

  # TODO: macOS
  prePatch = ''
    # Since version 2.5.0 of nlopt we need to link to libnlopt, as libnlopt_cxx
    # now seems to be integrated into the main lib.
    sed -i 's|nlopt_cxx|nlopt|g' cmake/modules/FindNLopt.cmake
  '';

  cmakeFlags = [
    "-DSLIC3R_STATIC=0"
    "-DSLIC3R_FHS=1"
    "-DSLIC3R_GTK=3"

    # BambuStudio-specific
    "-DBBL_RELEASE_TO_PUBLIC=1"
    "-DBBL_INTERNAL_TESTING=0"
    "-DDEP_WX_GTK3=ON"
    "-DSLIC3R_BUILD_TESTS=0"
    "-DCMAKE_CXX_FLAGS=-DBOOST_LOG_DYN_LINK"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "$out/lib"

      # Fixes intermittent crash
      # The upstream setup links in glew statically
      --prefix LD_PRELOAD : "${pkgs.glew.out}/lib/libGLEW.so"
    )
  '';

  # needed to prevent collisions between the LICENSE.txt files of
  # bambu-studio and orca-slicer.
  postInstall = ''
    mv $out/LICENSE.txt $out/share/OrcaSlicer/LICENSE.txt
  '';

  meta = with lib; {
    description = "G-code generator for 3D printers (Bambu, Prusa, Voron, VzBot, RatRig, Creality, etc";
    homepage = "https://github.com/SoftFever/OrcaSlicer";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      zhaofengli
      ovlach
      pinpox
    ];
    mainProgram = "orca-slicer";
    platforms = platforms.linux;
  };
}
