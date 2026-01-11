{
  description = "Flake development shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];
      imports = [
        inputs.treefmt-nix.flakeModule
        inputs.pre-commit-hooks.flakeModule
      ];
      perSystem = {
        config,
        pkgs,
        ...
      }: {
        treefmt = {
          projectRootFile = "flake.nix";

          programs = {
            alejandra.enable = true;
            deadnix.enable = true;
          };
        };

        pre-commit = {
          check.enable = true;

          settings = {
            hooks = {
              # Gotta look pretty
              treefmt = {
                enable = true;
                package = config.treefmt.build.wrapper;
              };

              # Check to make sure we don't commit secrets
              # TODO this always fails even though nothing is found?
              trufflehog.enable = false;
              ripsecrets.enable = true;

              # Prevents unencrypted sops files from being committed
              # TODO re-enable this when I rename secrets files to .yaml
              # it fails with an error if .yml files are used.
              # pre-commit-hook-ensure-sops = {
              #   enable = false;
              #   files = ".*\\.(yaml|yml|json)$";
              # };
            };
          };
        };

        devShells.default = pkgs.mkShellNoCC {
          # Stuff needed on dev computer
          buildInputs = with pkgs; [
          ];
          # Stuff needed on target arch (libs + build tools)
          nativeBuildInputs = with pkgs; [
          ];

          shellHook = ''
            ${config.pre-commit.installationScript}
          '';
        };
      };
    };
}
