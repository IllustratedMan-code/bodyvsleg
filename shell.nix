{ pkgs ? import <nixpkgs> {} }:
with pkgs;
let
  my-python-packages = python-packages: with python-packages; [
    pandas
    numpy
    matplotlib
  ];
  python-with-my-packages = python3.withPackages my-python-packages;
  R-with-my-packages = rWrapper.override{ packages = with rPackages; [
    ggplot2
    DESeq2
    tximport
    pheatmap
    knitr
  ];};
in
pkgs.mkShell {
  buildInputs = [
    python-with-my-packages
    R-with-my-packages
    # keep this line if you use bash
    pkgs.bashInteractive
    pkgs.plantuml

  ];
  shellHook = ''
    Rscript citations.r
  '';
}
