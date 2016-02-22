{ callPackage ? (import <nixpkgs> {}).callPackage }:

let dir = builtins.readDir ./.;
    f = name: dir.${name} == "regular" && builtins.substring (builtins.stringLength name - 4) 4 name == ".nix" && name != "default.nix";
    nix-files = builtins.filter f (builtins.attrNames dir);
    g = file: {
      name = builtins.substring 0 (builtins.stringLength file - 4) file;
      value = callPackage (./. + "/${file}") { };
    };
    packages = map g nix-files; in
builtins.listToAttrs packages