{
  inputs,
  cell,
}: let
  inherit (inputs.cells-lab.workflows.lib) mkCargoMake;
in {
  flow = mkCargoMake {
    source = cell.nixago.vast-cargo-make.configFile;
    # "all"
    args = ["smtp-url"];
  };
}
