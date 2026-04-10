# Neovim + AstroNvim (Nix Flake)

This is my personal Neovim configuration, packaged as a Nix flake. It wraps Neovim with my [AstroNvim](https://astronvim.com/) config so I can run my editor setup on any machine with a single command.

## Usage

Run directly from GitHub (no clone needed):

```bash
nix run github:ojwenzel/neovim
```

Or clone and run locally:

```bash
git clone git@github.com:ojwenzel/neovim.git
cd neovim
nix run .
```

On first launch, [lazy.nvim](https://github.com/folke/lazy.nvim) will bootstrap itself and install all plugins automatically. This takes 1–3 minutes and requires an internet connection. Subsequent launches are fast.

## How It Works

The flake wraps `neovim-unwrapped` from nixpkgs with:

- **AstroNvim config** from [ojwenzel/astronvim_config](https://github.com/ojwenzel/astronvim_config), bundled read-only in the Nix store
- **`NVIM_APPNAME=nvim-astro`** so all runtime state (plugins, cache, lockfile) is isolated to `~/.local/share/nvim-astro/` — your existing Neovim config is untouched
- **Runtime dependencies on PATH**: `git` (plugin installs), `gcc` (treesitter parsers), `ripgrep` and `fd` (telescope)

## Updating

```bash
nix flake update                    # update nixpkgs + astronvim config
nix flake update astronvim-config   # update only the astronvim config
```

## Requirements

[Nix](https://nixos.org/) with [flakes enabled](https://wiki.nixos.org/wiki/Flakes).
