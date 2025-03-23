{
  description = "A hello world with Nodejs (Typescript).";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { ... }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import inputs.nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.nodejs
            pkgs.nodePackages.npm
          ];
        };
        packages.default = pkgs.buildNpmPackage {
          pname = "hello-nodejs";
          version = "1.0.0";
          src = ./.;
          npmDepsHash = "sha256-BC98OvLhDl+ee5tet52tbj1ejXQmeBb6Hifn59eqw8w=";
        };
        apps.default = {
          type = "app";
          program = "${
            pkgs.writeShellApplication {
              name = "app";
              runtimeInputs = [ pkgs.nix ];
              text = ''
                ${pkgs.nodejs}/bin/node "$(nix build --no-link --print-out-paths)/lib/node_modules/hello-nodejs/dist/main.js"
              '';
            }
          }/bin/app";
        };
      }
    );
}
