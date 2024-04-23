{pkgs, inputs, ...}: 
let
  marketplace-extensions = with pkgs.vscode-marketplace; [
    nuxtr.nuxtr-vscode
    vue.volar
    over.bun-vscode
  ];
in {
  programs.vscode.extensions = with pkgs.vscode-extensions; [

  ] ++ marketplace-extensions;
}