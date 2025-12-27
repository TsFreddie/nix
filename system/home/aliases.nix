{ var, ... }:

{
  home.shellAliases = {
    nid = "${var.pwd}/nid.sh";
    nib = "${var.pwd}/nib.sh";
  };

  home.sessionPath = [
    "/home/${var.username}/.bun/bin"
  ];
}
