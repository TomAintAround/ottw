{
  description = "OTTW - Over The Top Widgets, made with Astal";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    astal,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};

        nativeBuildInputs = with pkgs; [
          gobject-introspection
          pkg-config
        ];

        buildInputs = [
          pkgs.glib
          pkgs.gtk4
          astal.packages.${system}.astal4
        ];
      in {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "ottw";
          version = "0.1";
          src = ./.;

          inherit nativeBuildInputs buildInputs;

          buildPhase = ''
            mkdir -p build
            make
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp build/widget $out/bin
          '';
        };

        devShells.default = pkgs.mkShell {
          inherit buildInputs nativeBuildInputs;

          shellHook = ''
            export CFLAGS="$(pkg-config --cflags glib-2.0 gtk4 astal-4-4.0)"
            export LDFLAGS="$(pkg-config --libs glib-2.0 gtk4 astal-4-4.0)"
          '';
        };
      }
    );
}
