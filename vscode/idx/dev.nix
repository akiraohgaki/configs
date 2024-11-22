{ pkgs, ... }: {
  channel = "unstable";

  packages = [
    pkgs.openssh
    pkgs.nano
    pkgs.deno
    pkgs.nodejs_latest
  ];

  env = { };

  idx = {
    extensions = [
      "EditorConfig.EditorConfig"
      "foxundermoon.shell-format"
      "mhutchie.git-graph"
      "denoland.vscode-deno"
    ];

    previews = {
      enable = false;
    };

    workspace = {
      onCreate = { };
      onStart = { };
    };
  };
}
