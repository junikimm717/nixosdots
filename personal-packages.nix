{config, pkgs, ...}:
with import <nixpkgs> {};
with builtins;

let
  # pythontex
  juni-pythontex =  let version = "2021"; in
  python3Packages.buildPythonApplication rec {
    pname = "pythontex";
    inherit (src) version;
    src = lib.head (builtins.filter (p: p.tlType == "run") texlive.pythontex.pkgs);
    propagatedBuildInputs = with python3Packages; [ pygments chardet ];
    dontBuild = true;
    doCheck = false;
    installPhase = ''
      runHook preInstall
      install -D ./scripts/pythontex/pythontex.py "$out"/bin/pythontex.py
      install -D ./scripts/pythontex/pythontex2.py "$out"/bin/pythontex2.py
      install -D ./scripts/pythontex/pythontex3.py "$out"/bin/pythontex3.py
      install -D ./scripts/pythontex/depythontex.py "$out"/bin/depythontex.py
      install -D ./scripts/pythontex/depythontex2.py "$out"/bin/depythontex2.py
      install -D ./scripts/pythontex/depythontex3.py "$out"/bin/depythontex3.py
      install -D ./scripts/pythontex/pythontex_2to3.py "$out"/bin/pythontex_2to3.py
      install -D ./scripts/pythontex/pythontex_engines.py "$out"/bin/pythontex_engines.py
      runHook postInstall
    '';
  };
in

{
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive)
    scheme-small
    collection-bibtexextra
    collection-latexextra
    collection-mathscience
    collection-pictures
    collection-formatsextra
    biblatex latexmk
    pythontex
    biblatex-mla;
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
  # latex generating script/build tool
  mktex = stdenv.mkDerivation {
    name = "mktex";
    src = fetchFromGitHub {
      owner = "junikimm717";
      repo = "mktex";
      rev = "29d14bf777596d62a5cae0b5e1b9aa696385a427";
      sha256 = "1ri6nw6053yipxfp6n6hin36md6dcz9yy502i2xkdsb6y7kdv6qp";
    };
    installPhase = ''
    mkdir -p $out
    cp -r $src $out/bin
    chmod +x $out/bin/mktex
    '';
  };
}
