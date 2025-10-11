{
  pkgs,
  lib,
  ...
}:

let
  pname = "wechat-devtools";
  version = "1.06.2504010-2";
  src = pkgs.fetchurl {
    url = "https://github.com/msojocs/wechat-web-devtools-linux/releases/download/v${version}/WeChat_Dev_Tools_v${version}_x86_64_linux.AppImage";
    sha256 = "AQggXU24U+JAXmXKcbpYJKbfce/JVEH+dkHA0tBfvIw=";
  };
in
pkgs.appimageTools.wrapType2 rec {
  inherit pname version src;

  extraPkgs =
    pkgs: with pkgs; [
      inetutils
      gnome2.GConf
      gnome-shell
      gtk3
      glib
      xorg.libX11
      xorg.libXcomposite
      xorg.libXrandr
      xorg.libxshmfence
      fontconfig
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ];

  nativeBuildInputs = [ pkgs.makeWrapper ];

  profile = ''
    export LC_ALL=zh_CN.UTF-8
    export LANG=zh_CN.UTF-8
  '';

  extraInstallCommands =
    let
      appimageContents = pkgs.appimageTools.extractType2 {
        inherit pname version src;
      };
    in
    ''
      cat $out/bin/${pname} << EOF
      export LD_LIBRARY_PATH="${pkgs.glib}/lib:${pkgs.gtk3}/lib:${pkgs.xorg.libxshmfence}/lib:\$LD_LIBRARY_PATH"
      # export PATH="${pkgs.glib}/bin:${pkgs.gtk3}/bin"
      ${pkgs.bash} $out/AppRun
      EOF
      install -m 444 -D ${appimageContents}/io.github.msojocs.wechat_devtools.desktop \
        $out/share/applications/wechat-devtools.desktop
      substituteInPlace $out/share/applications/wechat-devtools.desktop \
        --replace "Exec=bin/wechat-devtools" "Exec=${pname}"
      install -m 444 -D ${appimageContents}/wechat-devtools.png \
        $out/share/icons/hicolor/512x512/apps/wechat-devtools.png
    '';

  meta = with lib; {
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
    categories = [
      "Development"
      "IDE"
    ];
    description = "WeChat DevTools for Linux - Unofficial version";
    longDescription = ''
      WeChat DevTools for Linux - Unofficial version
    '';
    homepage = "https://github.com/msojocs/wechat-web-devtools-linux";
    # Removed unfree license - we're using this for personal development
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
