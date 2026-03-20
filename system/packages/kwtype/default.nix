{
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  qt6,
  kdePackages,
  libxkbcommon,
}:

stdenv.mkDerivation {
  pname = "kwtype";
  version = "master";

  src = fetchFromGitHub {
    owner = "Sporif";
    repo = "KWtype";
    rev = "master";
    sha256 = "11hc3fgfhcdxnn1hhcmmslx0zdrnxrb7nnq37x957jjxcdhbkhfl";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    kdePackages.wrapQtAppsHook
  ];
  buildInputs = [
    qt6.qtbase
    kdePackages.kwayland
    libxkbcommon
    qt6.qtwayland
  ];

  meta = {
    description = "A cli tool that provides virtual keyboard input on KDE Plasma Wayland";
    homepage = "https://github.com/Sporif/KWtype";
  };
}
