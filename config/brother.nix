{ pkgsi686Linux, lib, pkgs }:

let
  model = "mfcl3710cw";
  version = "1.0.2-0";
  src = builtins.fetchurl {
    #url = "https://download.brother.com/welcome/dlf103935/${model}pdrv-${version}.i386.deb";
    url =
      "https://download.brother.com/welcome/dlf103930/mfcl3710cwpdrv-1.0.2-0.i386.deb";
    sha256 = "06pysyw22jrgbllcycnd001ksfja3vaxkx99bybpriz25iykn8dx";
    #sha256 = "0j91nfw12pgsvlvpq9in8micpv9515ji0zl0jl8iic9cw248cf40";
    #sha256 = "09fhbzhpjymhkwxqyxzv24b06ybmajr6872yp7pri39595mhrvay";
  };
  reldir = "opt/brother/Printers/${model}/";

in rec {
  driver = pkgsi686Linux.stdenv.mkDerivation rec {
    inherit src version;
    name = "${model}drv-${version}";

    nativeBuildInputs = [ pkgs.dpkg pkgs.makeWrapper ];

    unpackPhase = "dpkg-deb -x $src $out";

    installPhase = ''
        dir="$out/${reldir}"
        substituteInPlace $dir/lpd/filter_${model} \
          --replace /usr/bin/perl ${pkgs.perl}/bin/perl \
          --replace "BR_PRT_PATH =~" "BR_PRT_PATH = \"$dir\"; #" \
          --replace "PRINTER =~" "PRINTER = \"${model}\"; #"
        wrapProgram $dir/lpd/filter_${model} \
          --prefix PATH : ${
            lib.makeBinPath [
              pkgs.coreutils
              pkgs.ghostscript
              pkgs.gnugrep
              pkgs.gnused
              pkgs.which
            ]
          }
      # need to use i686 glibc here, these are 32bit proprietary binaries
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        $dir/lpd/brmfcl3710cwfilter
    '';

    meta = {
      description = "Brother ${lib.strings.toUpper model} driver";
      homepage = "http://www.brother.com/";
      license = lib.licenses.unfree;
      platforms = [ "x86_64-linux" "i686-linux" ];
      maintainers = [ lib.maintainers.steveej ];
    };
  };

  cupswrapper = pkgs.stdenv.mkDerivation rec {
    inherit version src;
    name = "${model}cupswrapper-${version}";

    nativeBuildInputs = [ pkgs.dpkg pkgs.makeWrapper ];

    unpackPhase = "dpkg-deb -x $src $out";

    installPhase = ''
      basedir=${driver}/${reldir}
      dir=$out/${reldir}
      substituteInPlace $dir/cupswrapper/brother_lpdwrapper_${model} \
        --replace /usr/bin/perl ${pkgs.perl}/bin/perl \
        --replace "basedir =~" "basedir = \"$basedir\"; #" \
        --replace "PRINTER =~" "PRINTER = \"${model}\"; #"
      wrapProgram $dir/cupswrapper/brother_lpdwrapper_${model} \
        --prefix PATH : ${
          lib.makeBinPath [ pkgs.coreutils pkgs.gnugrep pkgs.gnused ]
        }
      mkdir -p $out/lib/cups/filter
      mkdir -p $out/share/cups/model
      ln $dir/cupswrapper/brother_lpdwrapper_${model} $out/lib/cups/filter
      ln $dir/cupswrapper/brother_${model}_printer_en.ppd $out/share/cups/model
    '';

    meta = {
      description = "Brother ${lib.strings.toUpper model} CUPS wrapper driver";
      homepage = "http://www.brother.com/";
      license = lib.licenses.gpl2;
      platforms = [ "x86_64-linux" "i686-linux" ];
    };
  };
}
