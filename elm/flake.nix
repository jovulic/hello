{
  description = "A hello world with Elm.";

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
            pkgs.elmPackages.elm
          ];
        };
        packages.default = pkgs.stdenv.mkDerivation {
          name = "hello-elm";
          src = ./.;
          outputs = [ "out" ];
          buildInputs = with pkgs; [
            elmPackages.elm
          ];
          buildPhase = ''
            set -x
            export HOME=$TMP
            elm make src/Main.elm --output dist/index.html
            set +x
          '';
          installPhase = ''
            set -x
            cp -r dist $out
            set +x
          '';
          __noChroot = true;
        };
      }
    );
}
