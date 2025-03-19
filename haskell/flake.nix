{
  description = "A hello world with Haskell.";

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
            pkgs.ghcid
            pkgs.cabal-install
          ];
        };
        packages.default = pkgs.haskellPackages.callCabal2nix "hello-haskell" inputs.self { };
      }
    );
}
