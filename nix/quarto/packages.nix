{
  inputs,
  cell,
}: let
  inherit (inputs.cells._automation.lib) __inputs__;
  inherit (__inputs__) vast2nix;
  inherit (inputs) nixpkgs;
in {
  # tenzir = nixpkgs'.poetry2nix.mkPoetryEnv {
  #   # projectDir = __inputs__.vast2nix.packages.${nixpkgs.system}.vast-latest.src + "/web";
  #   projectDir = ./.;
  #   overrides = nixpkgs'.poetry2nix.overrides.withDefaults (import ./overrides.nix);
  # };
}
