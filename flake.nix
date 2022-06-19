{
  inputs = {
    mach-nix.url = "mach-nix/3.5.0";
  };

  outputs = {self, nixpkgs, mach-nix }@inp:
    with import nixpkgs{system = "x86_64-linux";};
    let
      l = nixpkgs.lib // builtins;
      system = "x86_64-linux";
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
      '';
      MyRPackages = with pkgs.rPackages; [
        ggplot
        DESeq2
      ];
      Renv = pkgs.rWrapper.override{
        packages = with pkgs.rPackages; MyRPackages;
      };
      pyenv = mach-nix.lib.x86_64-linux.mkPython {
        python = "python38";
        requirements = lsp + python_requirements;
      };
    in
     {
      # enter this python environment by executing `nix shell .`
       packages = {
         ${system}.default = stdenv.mkDerivation{
          name = "RNA-seq output";
          buildInputs = [pyenv];
          src = ./.;
          installPhase = "mkdir $out";
         };
       };
       devshells = {
         ${system}.default = pkgs.mkShell{
           buildInputs = [pyenv plantuml];
         };
       };
    };
}
