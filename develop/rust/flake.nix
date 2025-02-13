{
  description = "Rust development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import nixpkgs { inherit system; };
          }
        );
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs }:
        let
          overrides = (builtins.fromTOML (builtins.readFile (self + "/rust-toolchain.toml")));
        in
        {
          default = pkgs.mkShell rec {
            shellHook = ''
              export name=$NID_NAME
              export PATH=$PATH:''${CARGO_HOME:-~/.cargo}/bin
              export PATH=$PATH:''${RUSTUP_HOME:-~/.rustup}/toolchains/$RUSTC_VERSION-x86_64-unknown-linux-gnu/bin/

              # fix tauri rendering
              export WEBKIT_DISABLE_DMABUF_RENDERER="1"
            '';

            nativeBuildInputs = with pkgs; [
              pkg-config
            ];
            buildInputs = with pkgs; [
              openssl
              glib.dev
              clang
              llvmPackages.bintools
              rustup
              gtk3
              libsoup_3
              webkitgtk_4_1
              glib-networking
            ];
            RUSTC_VERSION = overrides.toolchain.channel;

            # https://github.com/rust-lang/rust-bindgen#environment-variables
            LIBCLANG_PATH = pkgs.lib.makeLibraryPath [ pkgs.llvmPackages_latest.libclang.lib ];

            # Add precompiled library to rustc search path
            RUSTFLAGS = (
              builtins.map (a: ''-L ${a}/lib'') [
                # add libraries here (e.g. pkgs.libvmi)
              ]
            );

            LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath (buildInputs ++ nativeBuildInputs);

            # Add glibc, clang, glib, and other headers to bindgen search path
            BINDGEN_EXTRA_CLANG_ARGS =
              # Includes normal include path
              (builtins.map (a: ''-I"${a}/include"'') [
                # add dev libraries here (e.g. pkgs.libvmi.dev)
                pkgs.glibc.dev
              ])
              # Includes with special directory paths
              ++ [
                ''-I"${pkgs.llvmPackages_latest.libclang.lib}/lib/clang/${pkgs.llvmPackages_latest.libclang.version}/include"''
                ''-I"${pkgs.glib.dev}/include/glib-2.0"''
                ''-I${pkgs.glib.out}/lib/glib-2.0/include/''
              ];
          };
        }
      );
    };
}
