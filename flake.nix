{
  description = "A collection of hello world nix flakes.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
    go.url = "path:./go";
  };

  outputs =
    { ... }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import inputs.nixpkgs {
          inherit system;
        };
        lib = pkgs.lib;
      in
      {
        devShells.default =
          let
            getPackages = target: target.outputs.devShells.${system}.default.nativeBuildInputs;
            getShellHook = target: target.outputs.devShells.${system}.default.shellHook;
          in
          pkgs.mkShell {
            packages = lib.lists.unique (
              [
                pkgs.git
                pkgs.bash
              ]
              ++ (getPackages inputs.go)
            );
            shellHook = '''' + (getShellHook inputs.go);
          };
      }
    );
}
