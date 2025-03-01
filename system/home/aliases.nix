{ var, ... }:

{
  home.shellAliases = {
    nid = "${var.pwd}/nid.sh";
    nib = "${var.pwd}/rebuild.sh";
  };
}
