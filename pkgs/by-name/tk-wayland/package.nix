{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  tcl-9_1,
  at-spi2-atk,
  atk,
  cups,
  fontconfig,
  freetype,
  glfw3,
  harfbuzz,
  libdecor,
  libGL,
  libx11,
  libxkbcommon,
  speechd,
  systemd,
  wayland,
  wayland-protocols,
  wayland-scanner,
  zlib,
}:
stdenv.mkDerivation {
  pname = "tk-wayland";
  version = "9.2-unstable-2026-11-15";

  # Native Wayland is not part of the Tk 9.1 release series.
  src = fetchFromGitHub {
    owner = "tcltk";
    repo = "tk";
    rev = "2d5a2e9ff658d8beb3e2643d90b5a23d14dd850a";
    hash = "sha256-fjotBQVsa2y+NRnmSSq4Khklo7t4JrexahByjvHE7WE=";
  };

  patches = [ ./application-id.patch ];

  outputs = [
    "out"
    "dev"
    "man"
  ];
  strictDeps = true;
  enableParallelBuilding = true;
  # Tk embeds its include directory in the runtime library. Let the fixup hook
  # split development files after installation to avoid an output cycle.
  setOutputFlags = false;

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];
  buildInputs = [
    tcl-9_1
    at-spi2-atk
    atk
    cups
    fontconfig
    freetype
    glfw3
    harfbuzz
    libdecor
    libGL
    libxkbcommon
    speechd
    systemd
    wayland
    wayland-protocols
    zlib
  ];
  # Tk's public C API retains Xlib types on the Wayland backend.
  propagatedBuildInputs = [ libx11 ];

  preConfigure = ''
    configureFlagsArray+=(--mandir=$man/share/man --enable-man-symlinks)
    cd unix
  '';
  configureFlags = [
    "--with-tcl=${tcl-9_1}/lib"
    "--enable-wayland"
    "--disable-zipfs"
  ]
  ++ lib.optional stdenv.hostPlatform.is64bit "--enable-64bit";

  postInstall = ''
    ln -s "$out/bin/wish9.2" "$out/bin/wish"
    ln -s "$out/lib/libtcl9tk9.2.so" "$out/lib/libtk.so"
  '';

  passthru = {
    tcl = tcl-9_1;
    release = "9.2";
    libPrefix = "tcl9tk9.2";
    libdir = "lib/tk9.2";
  };

  meta = {
    description = "Tk widget toolkit with the native Wayland backend";
    homepage = "https://core.tcl-lang.org/tk/timeline?r=wayland";
    license = lib.licenses.tcltk;
    platforms = lib.platforms.linux;
    mainProgram = "wish";
  };
}
