{ nixpkgs ? import <nixpkgs> { }, buildFHSUserEnv ? nixpkgs.buildFHSUserEnv, xorg ? nixpkgs.xorg, stdenv ? nixpkgs.stdenv, writeTextFile ? nixpkgs.writeTextFile, fetchurl ? nixpkgs.fetchurl  }:

let version = "2-0-47-11";
    dominionfhs = buildFHSUserEnv { name = "dominion-fhs"; targetPkgs = pkgs: [ xorg.libX11 xorg.libXcursor xorg.libXrandr ]; };
    dominionsrc = stdenv.mkDerivation {
      name = "dominionsrc-${version}";
      src = fetchurl {
        url = "https://dominion.makingfun.co/Dominion_v${version}.tar.gz";
        sha256 = "1vxzrhaa11s1yhygy5dpswf5sl5ili7id5pvdnra1fbvvkwpjf1a";
      };
      phases = "unpackPhase";
      unpackPhase = ''
        mkdir $out
        cd $out
        tar xzf $src
      '';
   }; in
writeTextFile {
  name = "dominion-${version}";
  executable = true;
  destination = "/bin/dominion";
  text = ''
    #!/bin/sh
    ${dominionfhs}/bin/dominion-fhs -c ${dominionsrc}/Dominion.x86_64
  '';
}