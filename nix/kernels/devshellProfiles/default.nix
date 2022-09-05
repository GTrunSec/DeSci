{
  inputs,
  cell,
}: {
  default = {
    commands = [
      {
        name = "jupyterlab";
        command = ''
          set +u
          if [[ ! -d "$PRJ_ROOT/.jupyter" ]]; then
            jupyter lab build
          fi
          jupyter lab --ip $1 --port $2 --config $PRJ_ROOT/conf/jupyter_notebook_config.py
        '';
        help = "jupyterlab <IP> <PORT> <juliaPackageDir> | Example: jupyterlab 10.220.170.112 8888";
      }
    ];
  };
}
