{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-lock.follows = "nixpkgs";

    cells-lab.url = "github:GTrunSec/cells-lab";
    std.url = "github:divnix/std";
  };
  inputs = {
    julia2nix.url = "github:JuliaCN/Julia2Nix.jl";

    jupyterWith.url = "github:gtrunsec/jupyterWith/dev";
    jupyterWith.inputs.nixpkgs.follows = "nixpkgs";

    poetry2nix.url = "github:nix-community/poetry2nix";
    poetry2nix.inputs.nixpkgs.follows = "nixpkgs";

    matrix-attack-data.url = "github:GTrunSec/matrix-attack-data";
    matrix-attack-data.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {std, ...} @ inputs:
    std.growOn {
      inherit inputs;
      cellsFrom = ./nix;
      cellBlocks = [
        (std.blockTypes.installables "packages")

        (std.blockTypes.functions "devshellProfiles")
        (std.blockTypes.devshells "devshells")

        (std.blockTypes.runnables "entrypoints")

        (std.blockTypes.functions "library")

        (std.blockTypes.data "cargoMakeJobs")

        (std.blockTypes.functions "packages")

        (std.blockTypes.functions "overlays")

        (std.blockTypes.data "config")

        (std.blockTypes.nixago "nixago")
      ];
    } {
      devShells = inputs.std.harvest inputs.self ["main" "devshells"];
      packages = inputs.std.harvest inputs.self ["main" "packages"];
    };
}
