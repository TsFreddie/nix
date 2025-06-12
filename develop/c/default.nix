{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell.override
  {
    # Override stdenv in order to change compiler
    stdenv = pkgs.clangStdenv;
  }
  {
    shellHook = ''
      export name=$NID_NAME
      export SHELL=$NID_SHELL
    '';
    packages =
      with pkgs;
      [
        clang-tools
        cmake
        codespell
        conan
        cppcheck
        doxygen
        gtest
        lcov
        vcpkg
        vcpkg-tool
      ]
      ++ (if pkgs.stdenv.isDarwin && pkgs.stdenv.isAarch64 then [ ] else [ gdb ]);
  }
