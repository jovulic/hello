{
  description = "A hello world with Python.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { ... }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      # pythonLibPath = lib.makeLibraryPath (
      #   with pkgs;
      #   [
      #     zlib
      #     zstd
      #     stdenv.cc.cc
      #     curl
      #     openssl
      #     attr
      #     libssh
      #     bzip2
      #     libxml2
      #     acl
      #     libsodium
      #     util-linux
      #     xz
      #     systemd
      #   ]
      # );
      # python = stdenv.mkDerivation {
      #   name = "python";
      #   buildInputs = [ pkgs.makeWrapper ];
      #   src = pkgs.python;
      #   installPhase = ''
      #     mkdir -p $out/bin
      #     cp -r $src/* $out/
      #     wrapProgram $out/bin/python3 --set LD_LIBRARY_PATH ${pythonLibPath}
      #     wrapProgram $out/bin/python3.11 --set LD_LIBRARY_PATH ${pythonLibPath}
      #   '';
      # };
      let
        pkgs = import inputs.nixpkgs { inherit system; };
        inherit (pkgs) lib stdenv;
      in
      {
        devShells.default = pkgs.mkShell {
          NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [
            pkgs.zlib
            pkgs.zstd
            pkgs.stdenv.cc.cc
            pkgs.curl
            pkgs.openssl
            pkgs.attr
            pkgs.libssh
            pkgs.bzip2
            pkgs.libxml2
            pkgs.acl
            pkgs.libsodium
            pkgs.util-linux
            pkgs.xz
            pkgs.systemd
          ];
          NIX_LD = builtins.readFile "${stdenv.cc}/nix-support/dynamic-linker";
          packages = [
            (pkgs.writeShellScriptBin "python" ''
              export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
              exec ${pkgs.python3}/bin/python "$@"
            '')
            pkgs.uv
          ];
        };
        packages.default =
          with pkgs.python3Packages;
          buildPythonPackage {
            pname = "hello-python";
            version = "1.0.0";
            src = ./.;
            pyproject = true;
            build-system = [
              setuptools
            ];
          };
        apps.default = {
          type = "app";
          program = "${
            pkgs.writeShellApplication {
              name = "app";
              runtimeInputs = [ pkgs.nix ];
              text = ''
                python "$(nix build --no-link --print-out-paths)/lib/python3.12/site-packages/main.py"
              '';
            }
          }/bin/app";
        };
      }
    );
}
