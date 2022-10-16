{
  inputs,
  cell,
}: let
  l = nixpkgs.lib // builtins;
  inherit (inputs) nixpkgs std;
  inherit (cell.lib) __inputs__;
in {
  default = std.lib.dev.mkShell {
    name = "Data Science Threat Intelligence";

    std.adr.enable = false;

    packages = [ nixpkgs.quarto];

    imports = [
      inputs.std.std.devshellProfiles.default
      inputs.cells.julia.devshellProfiles.default
      # inputs.cells.kernels.devshellProfiles.default
      inputs.cells.vast.devshellProfiles.default
      inputs.julia2nix.julia2nix.devshellProfiles.dev
    ];

    commands = [
      {
        package = __inputs__.vast2nix.packages.${nixpkgs.system}.vast-bin;
      }
      {
        package = inputs.latest.legacyPackages.${nixpkgs.system}.poetry;
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

  doc = std.lib.dev.mkShell {
    nixago = [
      cell.nixago.mdbook
    ];
  };
}
