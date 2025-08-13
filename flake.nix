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
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages.default = pkgs.stdenv.mkDerivation rec {
          pname = "ottw";
          version = "0.1";
          src = ./.;

          nativeBuildInputs = with pkgs; [
            pkg-config
          ];

          buildInputs = with pkgs; [
            gtk4
            libxml2 # required to compress .ui files
          ];

          installPhase = ''
            mkdir -p $out/bin
            cp build/${pname} $out/bin
          '';
        };

        devShells.default = pkgs.mkShell {
          name = "ottwShell";
          inputsFrom = [self.packages.default];
          packages = with pkgs; [
            clang-tools
            vscode-css-languageserver
            yaml-language-server
            nixd
          ];
        };

        formatter = pkgs.callPackage ./nix/formatter.nix {};
      }
    );
}
