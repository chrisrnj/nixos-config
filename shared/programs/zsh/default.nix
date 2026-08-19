{ config, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      la = "ls -la";
      edit = "sudo -e";
      update = "sudo nixos-rebuild boot";
    };

    ohMyZsh = {
      enable = true;
      plugins = [
        "battery"
        "git"
        "gradle"
        "mvn"
        "pip"
        "podman"
        "python"
        "safe-paste"
        "ssh"
        "systemd"
        "tailscale"
        "vscode"
        "z"
      ];
      theme = "robbyrussell";
    };
  };

  users.users.christiano.shell = config.programs.zsh.package;
}
