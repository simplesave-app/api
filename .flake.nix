{
  description = "feenx-infra";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      with pkgs;
      {
        devShells.default = mkShell {
          packages = [
            # General tools
            docker
            docker-compose
            neovim

            # Ruby
            ruby_3_4
            bundler
            bundix

            # Rails deps
            clang
            libxml2
            libxslt
            readline
            sqlite
            openssl
            libyaml

            # PostgreSQL
            postgresql

            # Node.js
            nodejs
            nodePackages.pnpm

            # Alias scripts, workaround for https://github.com/direnv/direnv/issues/73
            # (pkgs.writeShellScriptBin "tf" "tofu $@")
          ];
        };
      }
    );
}