{
  lib,
  stdenv,
  fetchzip,
  ...
}:
stdenv.mkDerivation rec {
  pname = "catppuccin-cursors";
  version = "0.2.0";

  src = fetchzip {
    url = "https://github.com/catppuccin/cursors/releases/download/v${version}/Catppuccin-Mocha-Dark-Cursors.zip";
    sha256 = "sha256-I/QSk9mXrijf3LBs93XotbxIwe0xNu5xbtADIuGMDz8=";
  };

  installPhase = ''
    mkdir -p $out/share/icons/Catppuccin-Mocha-Dark-Cursors
    cp -va index.theme cursors $out/share/icons/Catppuccin-Mocha-Dark-Cursors
  '';

  meta = {
    description = "Soothing pastel mouse cursors";
    homepage = "https://github.com/catppuccin/cursors";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
  };
}
