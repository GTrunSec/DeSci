{
  inputs,
  cell,
} @ args: {
  poetryAttrs = import ./packages/poetryAttrs.nix args;

  nixpkgs = inputs.cells.common.lib.nixpkgs.appendOverlays [
    inputs.cells.common.lib.__inputs__.nixpkgs-hardenedlinux.python.overlays.default
    inputs.cells.common.lib.__inputs__.nixpkgs-hardenedlinux.common.lib.__inputs__.rust-overlay.overlays.default
  ];
}
