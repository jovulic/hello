{
  description = "A hello world with Rust.";

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
            pkgs.rustc
            pkgs.cargo
            # pkgs.rustPlatform.bindgenHook # https://wiki.nixos.org/wiki/Rust#Installating_with_bindgen_support
            # pkg-config # add pkg-config support
            pkgs.rustfmt
            pkgs.clippy
            pkgs.rust-analyzer
          ];
          # Certain Rust tools won't work without this
          # rust-analyzer from nixpkgs does not need this.
          # This can also be fixed by using oxalica/rust-overlay and specifying the rust-src extension
          # See https://discourse.nixos.org/t/rust-src-not-found-and-other-misadventures-of-developing-rust-on-nixos/11570/3?u=samuela. for more details.
          RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
        };
        packages.default = pkgs.rustPlatform.buildRustPackage {
          name = "hello-rust";
          src = ./.;
          cargoLock.lockFile = ./Cargo.lock;
          useFetchCargoVendor = true;
        };
      }
    );
}
