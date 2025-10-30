# Project: Hello

## Project Overview

This repository is a collection of "Hello World!" implementations in various languages, packaged using Nix flakes. The main purpose is to serve as a practice ground for Nix-related packaging and project structuring, including nested flakes.

## Building and Running

All sub-projects can be built and run using the following Nix commands from the root of the project directory:

- **Build:** `nix build .#<language>`
- **Run:** `nix run .#<language>`

Replace `<language>` with one of the supported languages: `elm`, `go`, `haskell`, `nodejs`, `python`, or `rust`.

## Development Conventions

The project follows a consistent structure, with each language residing in its own subdirectory. Each subdirectory is a self-contained project with its own Nix flake for packaging.

---

## Language-Specific Details

### Elm

- **Source:** `elm/src/Main.elm`
- **Dependencies:** `elm/elm.json`
- **Run:** `nix run .#elm`

### Go

- **Source:** `go/main.go`
- **Dependencies:** `go/go.mod`
- **Run:** `nix run .#go`

### Haskell

- **Source:** `haskell/app/Main.hs`
- **Cabal File:** `haskell/hello-haskell.cabal`
- **Run:** `nix run .#haskell`

### Node.js (TypeScript)

- **Source:** `nodejs/src/main.ts`
- **Dependencies:** `nodejs/package.json`
- **Build (JS):** `nix build .#nodejs` (This will compile TypeScript to JavaScript)
- **Run:** `nix run .#nodejs`

### Python

- **Source:** `python/src/main.py`
- **Dependencies:** `python/pyproject.toml`
- **Run:** `nix run .#python`

### Rust

- **Source:** `rust/src/main.rs`
- **Dependencies:** `rust/Cargo.toml`
- **Run:** `nix run .#rust`
