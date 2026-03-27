{
  description = "Custom Nix helpers";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    shell-utils = {
      url = "github:vncsmyrnk/shell-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fakeapi = {
      url = "github:vncsmyrnk/fakeapi";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      shell-utils,
      fakeapi,
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system} = {
        default = pkgs.symlinkJoin {
          name = "all-packages";
          paths = [
            shell-utils.packages.${system}.default
            fakeapi.packages.${system}.default
          ];
        };
      };
    };
}
