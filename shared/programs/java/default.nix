{ config, lib, pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.makeDesktopItem {
      name = "java";
      desktopName = "Java";
      exec = "${lib.getExe' config.programs.java.package "java"} -jar %f";
      terminal = false;
      mimeTypes = [ "application/x-java-archive" "application/x-jar" ];
      comment = "OpenJDK Runtime";
      icon = "java";
      type = "Application";
      categories = [ "Development" "Java" ];
    })
  ];

  # Java
  programs.java = {
    enable = true;
    package = pkgs.openjdk25;#temurin-bin-25;
    binfmt = true;
  };
}
