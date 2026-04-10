{
  description = "Neovim with AstroNvim configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    astronvim-config = {
      url = "github:ojwenzel/astronvim_config";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, astronvim-config }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          configDir = pkgs.stdenvNoCC.mkDerivation {
            name = "nvim-astro-config";
            src = astronvim-config;
            installPhase = ''
              mkdir -p $out/nvim-astro
              cp -r . $out/nvim-astro/

              # Redirect lazy-lock.json to writable data dir so lazy.nvim
              # doesn't try to write into the read-only Nix store
              substituteInPlace $out/nvim-astro/lua/lazy_setup.lua \
                --replace-fail \
                  'ui = { backdrop = 100 },' \
                  'ui = { backdrop = 100 }, lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",'
            '';
          };

          runtimeDeps = with pkgs; [
            git
            gcc
            ripgrep
            fd
          ];

          neovim-astro = pkgs.symlinkJoin {
            name = "neovim-astro";
            paths = [ pkgs.neovim-unwrapped ];
            nativeBuildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
              wrapProgram $out/bin/nvim \
                --set NVIM_APPNAME "nvim-astro" \
                --set XDG_CONFIG_HOME "${configDir}" \
                --suffix PATH : "${pkgs.lib.makeBinPath runtimeDeps}"
            '';
            meta.mainProgram = "nvim";
          };
        in
        {
          default = neovim-astro;
        }
      );
    };
}
