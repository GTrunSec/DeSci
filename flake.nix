{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    latest.url = "github:NixOS/nixpkgs";

    cells-lab.url = "github:GTrunSec/cells-lab";
    cells-lab.inputs.nixpkgs.follows = "nixpkgs";

    # std.url = "github:divnix/std";
    std.url = "github:gtrunsec/std/writeScript";
    std.inputs.nixpkgs.follows = "cells-lab/nixpkgs";
    std.inputs.n2c.follows = "n2c";

    n2c.url = "github:nlewo/nix2container";
    n2c.inputs.nixpkgs.follows = "cells-lab/std/nixpkgs";

    std-utils.url = "github:jmgilman/nix-utils";
    std-utils.inputs.nixpkgs.follows = "nixpkgs";
    std-utils.inputs.std.follows = "std";
  };
  inputs = {
    julia2nix.url = "github:JuliaCN/Julia2Nix.jl";
    julia2nix.inputs.nixpkgs.follows = "nixpkgs";

    jupyterWith.url = "github:tweag/jupyterWith?ref=refs/pull/419/head";
    # jupyterWith.url = "github:gtrunsec/jupyterWith/maintainer";
    jupyterWith.inputs.nixpkgs.follows = "nixpkgs";
    # jupyterWith.url = "/home/guangtao/ghq/github.com/tweag/jupyterWith";

    matrix-attack-data.url = "github:GTrunSec/matrix-attack-data";
    matrix-attack-data.inputs.nixpkgs.follows = "nixpkgs";

    dataflow2nix.url = "github:GTrunSec/dataflow2nix";
    dataflow2nix.inputs.nixpkgs.follows = "nixpkgs";
    dataflow2nix.inputs.tullia.follows = "tullia";

    tullia.url = "github:input-output-hk/tullia";
    # tullia.url = "/home/guangtao/ghq/github.com/input-output-hk/tullia";
    tullia.inputs.nixpkgs.follows = "nixpkgs";
    tullia.inputs.nix2container.follows = "n2c";
    tullia.inputs.nix-nomad.follows = "nix-nomad";
    nix-nomad.url = "github:tristanpemble/nix-nomad";

    users.follows = "cells-lab/std/blank";
  };

  outputs = {
    std,
    self,
    tullia,
    ...
  } @ inputs:
    std.growOn {
      inherit inputs;
      cellsFrom = ./nix;
      cellBlocks = with std.blockTypes;
        [
          (functions "devshellProfiles")

          (devshells "devshells")

          (runnables "entrypoints")

          (functions "lib")

          (data "cargoMakeJobs")

          (installables "packages" {ci.build = true;})

          (functions "overlays")

          (data "config")

          (nixago "nixago")

          (tullia.tasks "pipelines")
          (functions "actions")

          (data "composeJobs")
          (containers "oci-images")
          (runnables "operators")

          # nushell scripts
          (installables "nu")
        ]
        ++ [
          (containers "containers" {ci.publish = true;})
        ];
    } {
      devShells = inputs.std.harvest inputs.self ["automation" "devshells"];
      packages = inputs.std.harvest inputs.self [
        ["julia" "packages"]
        ["python" "packages"]
      ];
    } {
      process-compose =
        inputs.cells-lab.lib.mkProcessCompose ["composeJobs" "oci-images"]
        self {
          log_location = "$HOME/.cache/process-compose.log";
        };
    } (tullia.fromStd {
      tasks = std.harvest inputs.self [["julia" "pipelines"]];
      actions = std.harvest inputs.self [["julia" "actions"]];
    }) {
      templates = {
        tenzir = {
          description = "Tenzir's nix template for new projects";
          path = ./users/tenzir;
        };
      };
    };
  nixConfig = {
    extra-substituters = [
      "https://gtrunsec.cachix.org"
    ];
    extra-trusted-public-keys = [
      "gtrunsec.cachix.org-1:hqyEeSuO8HAm6xuChKrTJpLPpHUKtdjh4o/MRmcMQIo="
    ];
  };
}
