{
  description = "A collection of hello world nix flakes.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
    elm = {
      url = "./elm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    go = {
      url = "./go";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    haskell = {
      url = "./haskell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nodejs = {
      url = "./nodejs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    python = {
      url = "./python";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust = {
      url = "./rust";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
          in
          pkgs.mkShell {
            packages = lib.lists.unique (
              [
                pkgs.git
                pkgs.bash
              ]
              ++ (getPackages inputs.elm)
              ++ (getPackages inputs.go)
              ++ (getPackages inputs.haskell)
              ++ (getPackages inputs.nodejs)
              ++ (getPackages inputs.python)
              ++ (getPackages inputs.rust)
            );
          };
      }
    );
}
