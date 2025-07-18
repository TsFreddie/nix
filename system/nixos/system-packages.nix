{
  pkgs,
  extra,
  inputs,
  ...
}:

{
  environment.systemPackages =
    with pkgs;
    with extra;
    [
      git
      vim
      wget
      vscode
      nixd
      nixfmt-rfc-style
      thunderbird
      gamescope
      mpv
      vial
      btop-rocm

      xsettingsd
      xorg.xrdb

      kdePackages.partitionmanager
      kdePackages.kdenlive
      kdePackages.filelight
      kdePackages.kfind
      kdePackages.kcolorchooser
      kdePackages.ksystemlog
      kdePackages.krdc
      kdePackages.krfb
      kdePackages.kgpg
      kdePackages.kompare
      kdePackages.k3b
      kdePackages.skanlite
      kdePackages.kruler
      kdePackages.kleopatra
      kdePackages.ktorrent
      kdePackages.lokalize
      kdePackages.kclock
      kdePackages.kontact
      kdePackages.merkuro
      kdePackages.kdepim-addons
      kdePackages.plasma-browser-integration

      qalculate-qt

      ghostty
      gearlever

      p7zip
      unrar
      unzip
      zip

      bitwarden-desktop
      bitwarden-cli
      chromium
      libreoffice-qt6

      qt5.qttools
      qpwgraph

      okteta

      icu
      wl-clipboard

      zen-browser.default
      kwin-effects-forceblur.default

      dotnet-sdk_9
    ]
    ++ [
      # fixes gnome/gtk stuff
      adwaita-icon-theme
      adwaita-icon-theme-legacy
    ];

  environment.sessionVariables = {
    DOTNET_ROOT = "${pkgs.dotnet-sdk_9}/share/dotnet";
  };

  services.udev.packages = with pkgs; [
    vial
  ];

  programs.kde-pim = {
    enable = true;
    kmail = true;
    kontact = true;
    merkuro = true;
  };
}
