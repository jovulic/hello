{
  description = "A hello world with Go.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
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
            pkgs.git
            pkgs.bash
          ];
        };
        packages.default = pkgs.buildGoModule {
          pname = "hello-go";
          version = "1.0.0";
          src = ./.;
          vendorHash = null;
          postInstall = ''
            mv $out/bin/go $out/bin/hello-go
          '';
        };
      }
    );
}
