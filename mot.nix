{ pygame, fetchFromGitHub, stdenv, python2, makeWrapper }:

stdenv.mkDerivation {
  name = "mot-0.1";
  src = fetchFromGitHub {
    owner = "fkz";
    repo = "mot";
    rev = "master";
    sha256 = "1sysy2nv3rgydlrz0fkq2zyx3lcb1njp8dj077gmlnkg5vxn5xgx";
  };
  
  buildInputs = [ makeWrapper python2 ];
  
  installPhase = ''
    mkdir -p $out/share
    cp -R . $out/share/mot
    mkdir -p $out/bin
    makeWrapper ${python2}/bin/python2 $out/bin/mot \
      --run "cd $out/share/mot" \
      --prefix PYTHONPATH : "$(toPythonPath ${pygame})" \
      --add-flags $out/share/mot/main.py
  '';
}