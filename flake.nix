{
  inputs = {
    mach-nix.url = "mach-nix/3.5.0";
  };

  outputs = {self, nixpkgs, mach-nix }@inp:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs{inherit system;};
      lsp = ''
        python-lsp-server
        flake8
        pylint
        autopep8
        pydocstyle
        rope
        yapf
      '';
      python_requirements = ''
        pandas
        numpy
        matplotlib
        rich
      '';
      MyRPackages = with pkgs.rPackages; [
        ggplot2
        ggh4x
        DESeq2
        tidyverse
        tximport
        edgeR
        styler
        svglite
        ggVennDiagram
        cowplot
      ];
      Renv = pkgs.rWrapper.override{
        packages = with pkgs.rPackages; MyRPackages;
      };
      pyenv = mach-nix.lib."${system}".mkPython {
        python = "python38";
        requirements = lsp + python_requirements;
      };
      deps = with pkgs; [pyenv Renv which blast];
    in
     {
       packages."${system}" = with pkgs; {
         default = stdenv.mkDerivation{
          name = "pipeline";
          buildInputs = deps;
          src = self;
          buildPhase = ''
          '';
          installPhase = ''
            mkdir $out

            cp -r scripts $out/scripts
            cp -r data $out/data

            mkdir $out/bin
            echo out=$out >> $out/bin/pipeline
            echo src=$src >> $out/bin/pipeline
            echo python=$(which python) >> $out/bin/pipeline

            cat $src/scripts/pipeline.sh >> $out/bin/pipeline

            chmod +x $out/bin/pipeline
          '';
         };
       };
       devShells.${system} = with pkgs; {
         default = mkShell{
           buildInputs = deps ++ [plantuml];
         };
       };
    };
}
