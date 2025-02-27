{
  description = "Nix function(s) for creating ruby environments";

  inputs = {
    nixpkgs.url = "nixpkgs";

    # a fork that supports platform dependant gem
    bundix.url = "github:sagittaros/bundix";
  };

  outputs = { self, nixpkgs, bundix }: {
    lib = import ./. bundix;

    # preset gemsets
    presets = { devmode = import ./presets/devmode/gemset.nix; };

    overlays.ruby = import ./modules/overlays/ruby-overlay.nix;

    templates = {
      simple-app = {
        path = ./examples/simple-app;
        description = "A flake that drives a simple ruby app";
      };
      docker-app = {
        path = ./examples/docker-app;
        description = "A flake that builds docker image";
      };
    };
    templates.default = self.templates.simple-app;

    devShells.x86_64-linux.default = let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ (import ./modules/overlays/ruby-overlay.nix) ];
      };
    in import ./shell.nix { inherit pkgs bundix; };
  };
}
