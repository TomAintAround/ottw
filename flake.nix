{
  description = "OTTW - Over The Top Widgets, made with GTK 4";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};

        nativeBuildInputs = with pkgs; [
          pkg-config
        ];

        buildInputs = with pkgs; [
          gtk4
        ];
      in {
        packages.default = pkgs.stdenv.mkDerivation rec {
          pname = "ottw";
          version = "0.1";
          src = ./.;

          inherit nativeBuildInputs buildInputs;

          buildPhase = ''
            make
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp build/${pname} $out/bin
          '';
        };

        devShells.default = pkgs.mkShell {
          inherit buildInputs nativeBuildInputs;

          shellHook = ''
            export CFLAGS="$(pkg-config --cflags gtk4)"
            export LDFLAGS="$(pkg-config --libs gtk4)"
          '';
        };

        formatter = pkgs.callPackage ./nix/formatter.nix {};
      }
    );
}
