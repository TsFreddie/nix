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
      kdePackages.kcolorpicker
      kdePackages.ksystemlog
      kdePackages.krdc
      kdePackages.kgpg
      kdePackages.kompare
      kdePackages.k3b
      kdePackages.skanlite
      kdePackages.kruler
      kdePackages.kleopatra
      kdePackages.ktorrent
      kdePackages.lokalize
      kdePackages.kclock
      kdePackages.kmail
      kdePackages.kontact
      kdePackages.merkuro
      kdePackages.kdepim-addons

      qalculate-qt

      ghostty
      gearlever

      p7zip
      unrar

      bitwarden-desktop
      bitwarden-cli
      chromium

      qt5.qttools
      qpwgraph

      zen-browser.default

      icu
    ]
    ++ [
      # fixes gnome/gtk stuff
      adwaita-icon-theme
      adwaita-icon-theme-legacy
    ];

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
