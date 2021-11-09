{
  description = "A simple bash library for your scripting needs";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";

  outputs = { self, flake-utils, nixpkgs, }:
    with flake-utils.lib;
    (eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        };
      in
      {

        packages.bash-lib = pkgs.bash-lib;

        defaultPackage = self.packages.${system}.bash-lib;

      })) // {
      checks.x86_64-linux = {
        runAndCheckDemo =
          let
            pkgs = import nixpkgs {
              system = "x86_64-linux";
              overlays = [ self.overlay ];
            };
          in
          pkgs.runCommand "runAndCheckDemo" { src = ./.; nativeBuildInputs = [ pkgs.shellcheck ]; } ''
            unpackFile "$src"
            cd */
            shellcheck ./bash-lib.sh
            shellcheck -x ./demo.sh

            chmod +w . demo.sh
            sed '/^fatal/d' -i demo.sh

            patchShebangs ./demo.sh
            ./demo.sh

            touch $out
          '';
      };

      overlay = final: prev: {
        bash-lib = final.writeTextFile {
          name = "bash-lib.sh";
          text = builtins.readFile ./bash-lib.sh;
        };
      };
    };
}
