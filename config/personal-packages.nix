{ config, pkgs, ... }:
with builtins;
with pkgs; {
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive)
      scheme-small collection-bibtexextra collection-latexextra
      collection-mathscience collection-pictures collection-formatsextra
      biblatex latexmk pythontex biblatex-mla asymptote collection-fontsextra;
  });

  # meeting joining program
  mt = stdenv.mkDerivation {
    name = "mt";
    src = fetchurl {
      url = "https://github.com/junikimm717/mt/releases/download/33627ab/mt";
      sha256 =
        "ec2362864527e215594b1c2279d9c50093dcaf5537a61342c2db2575406962f6";
    };
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cp -r $src $out/bin/mt
      chmod +x $out/bin/mt
    '';
  };
  autoclose = pkgs.vimUtils.buildVimPlugin {
    name = "vim-autoclose";
    src = pkgs.fetchFromGitHub {
      owner = "Townk";
      repo = "vim-autoclose";
      rev = "a9a3b7384657bc1f60a963fd6c08c63fc48d61c3";
      sha256 = "12jk98hg6rz96nnllzlqzk5nhd2ihj8mv20zjs56p3200izwzf7d";
    };
  };
}
