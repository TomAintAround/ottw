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
        #TODO: Finish this
        packages.default = pkgs.callPackage ./nix/package.nix {version = "0.1";};

        devShells.default = pkgs.mkShell {
          name = "ottwShell";
          inputsFrom = [self.packages.${system}.default];
          packages = with pkgs; [
            clang-tools
            vscode-css-languageserver
            yaml-language-server
            nixd
            cmake-language-server
          ];
        };

        formatter = pkgs.callPackage ./nix/formatter.nix {};
      }
    );
}
