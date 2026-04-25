{
  description = "Mona";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    {
      devShells.x86_64-linux.default =
        let
          pkgs = import nixpkgs { system = "x86_64-linux"; };
        in
        pkgs.mkShell {
          packages = with pkgs; [
            pkg-config
            gtk3
            glib
            gdk-pixbuf
            sysprof
            libepoxy
            fontconfig
            libsysprof-capture
            clang
            pcre2
            zlib
            ninja
            libX11
            libXcursor
            libXrandr
            libXi
            cairo
            pango
          ];
          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
            pkgs.libepoxy
            pkgs.fontconfig
            pkgs.gtk3
            pkgs.glib
            pkgs.pango
            pkgs.cairo
            pkgs.gdk-pixbuf
          ];

          PKG_CONFIG_PATH = pkgs.lib.makeSearchPath "lib/pkgconfig" [
            pkgs.gtk3
            pkgs.glib
            pkgs.fontconfig
            pkgs.libsysprof-capture
            pkgs.libepoxy
            pkgs.sysprof
            pkgs.gdk-pixbuf
          ];
        };
    };
}
