{
  pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/26d499fc9f1d567283d5d56fcf367edd815dba1d.tar.gz") { config = {}; overlays = []; } }:
let
  _unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/02032da4af073d0f6110540c8677f16d4be0117f.tar.gz") {};
in
pkgs.mkShellNoCC {
  packages = with pkgs; [
    elixir_1_18
    elixir-ls
    marksman # lsp for markdown
    mise # nix needs this to work with elixir-ls and hx for some reason
  ] ++ [
#    (_unstable.deno)
  ];
}
