{ pkgs }:

final: prev: {
  input-remapper = prev.input-remapper.overrideAttrs (old: {
    version = "2.1.1";
    src = prev.fetchFromGitHub {
      owner = "sezanzeb";
      repo = "input-remapper";
      rev = "2.1.1";
      hash = "sha256-GMKcs2UK1yegGT/TBsLGgTBJROQ38M6WwnLbJIuAZwg=";
    };
    patches = (old.patches or [ ]) ++ [
      (prev.fetchpatch {
        url = "https://github.com/TsFreddie/input-remapper/commit/d90dbe182a5f982060645f1fc50ba51f0c7ef9c9.patch";
        hash = "sha256-JdKLzSzp7IsF1BOT1UOytei9dNN7/x/7B3LGo+RKwwM=";
      })
    ];

    pythonImportsCheck = old.pythonImportsCheck ++ [
      "psutil"
    ];

    propagatedBuildInputs = old.propagatedBuildInputs ++ [
      pkgs.python3Packages.psutil
    ];

    postInstall = ''
      substituteInPlace data/99-input-remapper.rules \
        --replace-fail 'RUN+="/bin/input-remapper-control' "RUN+=\"$out/bin/input-remapper-control"
      substituteInPlace data/input-remapper.service \
        --replace-fail 'ExecStart=/usr/bin/input-remapper-service' "ExecStart=$out/bin/input-remapper-service"

      install -m644 -D -t $out/share/applications/ data/*.desktop
      install -m644 -D -t $out/share/polkit-1/actions/ data/input-remapper.policy
      install -m644 -D data/99-input-remapper.rules $out/etc/udev/rules.d/99-input-remapper.rules
      install -m644 -D data/input-remapper.service $out/lib/systemd/system/input-remapper.service
      install -m644 -D data/input-remapper.policy $out/share/polkit-1/actions/input-remapper.policy
      install -m644 -D data/inputremapper.Control.conf $out/etc/dbus-1/system.d/inputremapper.Control.conf
      install -m644 -D data/input-remapper.svg $out/share/icons/hicolor/scalable/apps/input-remapper.svg
      install -m644 -D -t $out/usr/share/input-remapper/ data/*

      # Only install input-remapper prefixed binaries, we don't care about deprecated key-mapper ones
      install -m755 -D -t $out/bin/ bin/input-remapper*
    '';
  });
}
