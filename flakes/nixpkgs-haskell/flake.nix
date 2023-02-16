{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    haskell-flake.url = "github:srid/haskell-flake";
    mission-control.url = "github:Platonic-Systems/mission-control";
  };

  outputs = inputs@{ flake-parts, nixpkgs, treefmt-nix,mission-control, haskell-flake,... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # To import a flake module
        # 1. Add foo to inputs
        # 2. Add foo as a parameter to the outputs function
        # 3. Add here: foo.flakeModule
        treefmt-nix.flakeModule
        mission-control.flakeModule
        haskell-flake.flakeModule
      ];
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.
        haskellProjects.main = {
          packages.PLACEHOLDER.root = ./.;
          devShell = {
            enable = true;
            # add shellHook when merged
          };
        };
        # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
        treefmt.programs = {
          cabal-fmt.enable = true;
          hlint.enable = true;
        };
        devShells.default = config.devShells.main;
      };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.
      };
    };
}
