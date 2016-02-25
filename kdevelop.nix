{ pkgs ? import <nixpkgs> { } }:
with pkgs;
# use same qt as used in kde
let qt5 = qt55; in
let nbuildInputs = [
      kde5.extra-cmake-modules
      qt5.qtdeclarative
      qt5.qtwebkit
      qt5.qtscript
      bzip2
      libxslt
      libxml2
      shared_mime_info
      kde5.oxygen-icons5
      giflib
      vlc # ?  really ???

      doxygen gperf
      #bzr
      xapian
      fontforge libgcrypt attr
      networkmanager # wtf??
      boost

      kde5.knewstuff kde5.knotifyconfig kde5.threadweaver
      kde5.kcmutils

      gtk3 libxslt
      # libpwquality-dev modemmanager-dev
      #libxcb-keysyms1-dev libepoxy-dev libpolkit-agent-1-dev libnm-util-dev libnm-glib-dev libegl1-mesa-dev
      #libxcb-xkb-dev libqt5x11extras5-dev libwww-perl libxml-parser-perl libjson-perl libboost-dev
      gstreamer libarchive  # libgstreamer-plugins-base-1.0-dev libgstreamer libarchive-dev liblmdb-dev
      qt5.qttools qt5.qtsvg qt5.qtxmlpatterns kde5.plasma-framework kde5.plasma-workspace
      # libkf5guiaddons-dev libkf5widgetsaddons-dev libkf5threadweaver-dev libkf5xmlgui-dev libkf5itemmodels-dev libkf5jobwidgets-dev libkf5kcmutils-dev kio-dev libkf5newstuff-dev libkf5notifications-dev libkf5notifyconfig-dev libkf5parts-dev libkf5texteditor-dev libkf5declarative-dev kdoctools-dev libgrantlee5-dev libkomparediff2-dev libkf5runner-dev libkf5sysguard-dev
      grantlee5 #libgrantlee5-dev libgrantlee-templates5 libgrantlee-textdocument5

      #okteta plugin
      # libkasten3okteta1controllers1 libkasten3controllers3 okteta okteta-dev

      # kdevelop
      kde5.kdoctools llvmPackages.clang-unwrapped llvm

      hicolor_icon_theme

      # for the python plugin
      python35
    ];
  callPackage = lib.callPackageWith (pkgs // { inherit nbuildInputs; });
  lambdapkgs = {

    kdevelop = { nbuildInputs, kdevplatform, kdevelop-pg-qt }:
      stdenv.mkDerivation {
        name = "kdevelop-4.90.91";
        src = fetchurl {
          url = mirror://kde/unstable/kdevelop/4.90.91/src/kdevelop-4.90.91.tar.xz;
          sha256 = "0jfp64ky5p4k0pjss2kpan0g6k1rh1ms94sc5r64bxaz8b37z07b";
        };
        buildInputs = nbuildInputs ++ [ kdevplatform kdevelop-pg-qt ];
      };

    kdevplatform = { nbuildInputs, libkomparediff2 }:
      stdenv.mkDerivation {
        src = fetchurl {
          url = mirror://kde/unstable/kdevelop/4.90.91/src/kdevplatform-4.90.91.tar.xz;
          sha256 = "0vqrczbn9w2gnmf4kprp4cyiznk5lm8s0xzy9177j1rj0z118h3f";
        };
        name = "kdevplatform-4.90.91";
        buildInputs = nbuildInputs ++ [libkomparediff2];
      };

    libkomparediff2 = { nbuildInputs }:
      stdenv.mkDerivation {
        name = "libkomparediff2-15.12.2";
        src = fetchurl {
          url = mirror://kde/stable/applications/15.12.2/src/libkomparediff2-15.12.2.tar.xz;
          sha256 = "18hphlqdgnis4j4pr1cm6iy9f0bmqa3mn4w5gwmrl0khljfrv1fx";
        };
        buildInputs = nbuildInputs;
      };

    kdevelop-pg-qt = { nbuildInputs }:
      stdenv.mkDerivation {
        name = "kdevelop-pg-qt-1.90.92";
        src = fetchurl {
          url = mirror://kde/unstable/kdevelop-pg-qt/1.90.92/src/kdevelop-pg-qt-1.90.92.tar.xz;
          sha256 = "1cf5z0i1wjlmdmm1ahadgm2cd81gc31nhzngrxyij9vpyz4ss8m5";
        };
        buildInputs = nbuildInputs;
      };
  };

  pkgs = lib.mapAttrs (k: v: callPackage v {}) lambdapkgs;
in pkgs



#stdenv.mkDerivation {
#  name = "kdevplatform";
#  nbuildInputs = [
#    # TODO: figure out which of the packages are really needed and for which plugin etc.#
##
#
#    ];
#    shellHook = ''
#      alias cmake="cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=${builtins.toString ./installation}"
#      export CMAKE_PREFIX_PATH=${builtins.toString ./installation}:$CMAKE_PREFIX_PATH
#    '';
#}