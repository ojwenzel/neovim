# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A Nix flake that wraps `neovim-unwrapped` with the AstroNvim config from `github:ojwenzel/astronvim_config`. Running `nix run` launches Neovim pre-configured with AstroNvim — no manual config cloning needed.

## Build and Run

```bash
nix build .          # produces ./result/bin/nvim
nix run .            # build + launch in one step
nix flake check      # validate flake evaluates correctly
```

Files must be git-tracked for the flake to see them (`git add` before `nix build`).

## Architecture

The entire project is a single `flake.nix` with three pieces:

1. **Config derivation** (`nvim-astro-config`) — copies the AstroNvim config input into `$out/nvim-astro/` in the Nix store
2. **Wrapper** (`neovim-astro`) — `symlinkJoin` of `neovim-unwrapped` + `makeWrapper` that sets:
   - `NVIM_APPNAME=nvim-astro` — isolates runtime data to `~/.local/share/nvim-astro/`, `~/.local/state/nvim-astro/`, etc.
   - `XDG_CONFIG_HOME` — points to the store config derivation (read-only)
   - `PATH` suffix — appends `git`, `gcc`, `ripgrep`, `fd` (lazy.nvim needs git; treesitter needs gcc; telescope uses rg/fd)
3. **Multi-system support** — `genAttrs` over linux/darwin × x86_64/aarch64, no `flake-utils` dependency

Config is read-only in the Nix store. All mutable state (plugins, lockfile, cache) lives under `~/.local/share/nvim-astro/`. On first run, lazy.nvim bootstraps itself and installs plugins (requires internet, takes 1-3 min).

## Commit Message Format

```
verb: concise summary

- previously, ... now ...
- previously, ... now ...
```

The first line is a lowercase verb followed by a colon and short summary (e.g. `add: nix flake for wrapped neovim`). The body lists changes as bullet points describing what changed: `previously, X. now, Y.`

## Updating Inputs

```bash
nix flake update                    # update all inputs
nix flake update astronvim-config   # update only the AstroNvim config
```
