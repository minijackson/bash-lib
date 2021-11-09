{
  description = "A simple bash library for your scripting needs";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, flake-utils }:
    with flake-utils.lib;
    eachSystem allSystems (system: {

      # Convert a path to a derivation
      # This is done so we don't depend on nixpkgs
      packages.bash-lib = with builtins; derivation {
        name = "bash-lib.sh";
        src = readFile ./bash-lib.sh;
        inherit system;

        builder = "/bin/sh";
        args = [
          (toFile "builder.sh" ''
            echo "$src" > $out
          '')
        ];
      };

      defaultPackage = self.packages.${system}.bash-lib;
    });
}
