{
  cell,
  inputs,
}: let
  cmd = type: text: {
    command = {inherit type text;};
  };
in {
  julia = {pkgs, ...}:
    cmd "shell" "julia --version"
    // {dependencies = [cell.packages.julia-wrapped];};

  julia-cli = {pkgs, ...}:
    cmd "shell" "cli df x"
    // {dependencies = [inputs.cells.julia.entrypoints.cli];};

  ci = {
    config ? {},
    pkgs,
    ...
  }:
    cmd "shell" ''
      echo Fact:
      cat ${pkgs.writeText "fact.json" (builtins.toJSON (config.facts.push or ""))}
      echo CI passed
    ''
    // {
      after = [
        "update"
        "julia"
      ];
    };

  update = {
    pkgs,
    config,
    ...
  }:
    cmd "shell" "nix flake lock --update-input std"
    // {
      preset.nix.enable = true;
      # mkdir -p /local/home for isolation
      env.HOME = "/home";
    };

  jnumpy = {
    pkgs,
    lib,
    ...
  }:
    cmd "shell" ''
      echo "$PATH" | tr : "\n"
      nix build -Lv .#jnumpy
    ''
    // {
      preset.nix.enable = true;
      memory = 4 * 1024;
    };
}
