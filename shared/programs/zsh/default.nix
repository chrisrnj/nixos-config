{ config, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      la = "ls -lAh";
      edit = "sudo -e";
      update = "cd /etc/nixos && sudo nix flake update && sudo nixos-rebuild switch --flake .#${config.networking.hostName}";
    };

    ohMyZsh = {
      enable = true;
      plugins = [
        "battery"
        "git"
        "gradle"
        "mvn"
        "podman"
        "python"
        "safe-paste"
        "ssh"
        "systemd"
        "tailscale"
        "vscode"
        "z"
      ];
      theme = "intheloop";
    };
  };

  users.users.christiano.shell = config.programs.zsh.package;
}
