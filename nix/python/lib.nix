{
  inputs,
  cell,
} @ args: {
  poetryPackages = import ./packages/poetryPackages.nix args;

  nixpkgs = inputs.cells.common.lib.nixpkgs.appendOverlays [
    inputs.dataflow2nix.common.overlays.mach-nix
    inputs.cells.common.lib.__inputs__.nixpkgs-hardenedlinux.python.overlays.default
    inputs.cells.common.lib.__inputs__.nixpkgs-hardenedlinux.common.lib.__inputs__.rust-overlay.overlays.default
  ];
}
