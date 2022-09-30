{
  inputs,
  cell,
}: let
  l = nixpkgs.lib // builtins;
  inherit (inputs) nixpkgs std;
  inherit (cell.library) __inputs__;
in {
  default = inputs.cells-lab.main.library.mergeDevShell {
    mkShell = nixpkgs.mkShell {
      nativeBuildInputs = with nixpkgs; [openssl];
      buildInputs = with nixpkgs; [
        inputs.cells.python.packages.poetryEnv
      ];
    };

    devshell = std.std.lib.mkShell {
      name = "Data Science Threat Intelligence";

      std.adr.enable = false;

      imports = [
        inputs.std.std.devshellProfiles.default
        inputs.cells.julia.devshellProfiles.default
        inputs.cells.kernels.devshellProfiles.default
        inputs.cells.vast.devshellProfiles.default
        inputs.julia2nix.julia2nix.devshellProfiles.dev
      ];

      commands = [
        {
          name = "jupyter";
          command = "${inputs.cells.kernels.packages.jupyterEnvironment}/bin/jupyter $@";
        }
        {
          package = __inputs__.vast2nix.packages.${nixpkgs.system}.vast-bin;
        }
      ];

      nixago =
        [
          cell.nixago.treefmt
          cell.nixago.just
          cell.nixago.mdbook
        ]
        ++ l.attrValues inputs.cells.vast.nixago;
    };
  };
  doc = std.std.lib.mkShell {
    nixago = [
      cell.nixago.mdbook
    ];
  };
}
