{
  description = "Linux kernel compilation environment targeting arm";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (final: prev: {
            gcc-linaro = prev.callPackage ./packages/linaro.nix {};
          })
        ];
      };
    in {
      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs.buildPackages; [
          gcc
          binutils
          gnumake
          bc
          bison
          flex
          openssl
          ncurses
          pkg-config
          zlib

          gcc-linaro
        ];

        shellHook = ''
          export ARCH=arm
          export CROSS_COMPILE=arm-linux-gnueabihf-
        '';
      };
    };
}
