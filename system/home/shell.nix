{ lib, var, ... }:

{
  # zsh
  programs.zsh.enable = true;
  programs.zsh.autosuggestion.enable = true;
  programs.zsh.initContent = ''
    if [[ -f "$HOME/.myrc" ]]; then
      source "$HOME/.myrc"
    fi
  '';

  # zoxide
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  home.shellAliases = {
    cd = "z";
  };

  # fzf
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  # starship
  programs.starship.enable = true;
  programs.starship.enableBashIntegration = true;
  programs.starship.enableZshIntegration = true;
  programs.starship.settings = {
    add_newline = false;
    format = lib.concatStrings [
      "$line_break"
      "$directory$all"
      "$line_break"
      "[$character](bold green)"
    ];
    scan_timeout = 500;
    character = {
      success_symbol = " >";
      error_symbol = "[!>](red)";
    };
    nix_shell = {
      format = "via [$symbol$name$state]($style) ";
      impure_msg = "";
      pure_msg = " (pure)";
    };
  };

  # custom utilities path
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/utils"
    "$HOME/.bun/bin"
  ];

  # kitty settings
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "Sarasa-Term-SC-Regular";
      bold_font = "Sarasa-Term-SC-Bold";
      italic_font = "Sarasa-Term-SC-Italic";
      bold_italic_font = "Sarasa-Term-SC-Bold-Italic";
    };
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g extended-keys on
      set -g extended-keys-format csi-u
    '';
  };

  # nid
  home.shellAliases = {
    nid = "/home/${var.username}/nix/nid.sh";
  };

  # editor
  programs.fresh-editor = {
    enable = true;
  };

  home.sessionVariables = {
    EDITOR = "fresh";
    VISUAL = "fresh";
  };
}
