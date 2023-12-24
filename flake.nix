{
  description = "Suika Game in Bevy!";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs { inherit system overlays; };
      in
      with pkgs;
      {
        devShells.default = mkShell rec {
          nativeBuildInputs = [
            pkg-config
            (rust-bin.fromRustupToolchainFile ./rust-toolchain)
            llvmPackages.clang
            llvmPackages.bintools
          ];
        
          buildInputs = [
            systemd.dev
            alsa-lib.dev
            vulkan-loader
            xorg.libX11
            xorg.libXcursor
            xorg.libXi
            xorg.libXrandr
            libxkbcommon
            wayland
          ];

          LD_LIBRARY_PATH = lib.makeLibraryPath buildInputs;
        };
      }
    );
}
