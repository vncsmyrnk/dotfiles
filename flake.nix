{
  description = "Custom Nix helpers";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    shell-utils.url = "github:vncsmyrnk/shell-utils";
    shell-utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, shell-utils }:
    let system = "x86_64-linux";
    in { packages.${system}.default = shell-utils.packages.${system}.default; };
}
