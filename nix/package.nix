{
  version,
  stdenv,
  lib,
  cmake,
  pkg-config,
  gtk4,
  gtk4-layer-shell,
  libxml2,
}:
stdenv.mkDerivation {
  pname = "ottw";
  inherit version;
  src = ../.;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    gtk4
    gtk4-layer-shell
    libxml2 # required to compress .ui files
  ];

  meta = with lib; {
    homepage = "https://github.com/TomAintAround/ottw";
    description = "Over The Top Widgets, made with GTK 4";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "ottw";
  };
}
