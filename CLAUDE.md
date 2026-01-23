# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a dotfiles repository managed with GNU Stow. Configuration files are organized to mirror their target locations relative to `$HOME`.

## Installation

```bash
# Prerequisites
sudo apt install stow  # or brew install stow on macOS
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install all dotfiles
cd ~/dotfiles
stow .
```

## Key Components

- **Fish shell**: Custom prompt with git status, system greeting with disk/network info, abbreviations (`ll`, `glo`, `vi`)
- **Neovim**: Based on kickstart.nvim with lazy.nvim plugin manager. Leader key is `<space>`. LSP configured for Lua and Rust
- **Tmux**: vim-tmux-navigator integration, TPM plugin manager. Reload config with `prefix + R`
- **Alacritty**: Iosevka font, gruvbox-dark-hard theme
- **VS Code**: Extensions synced via `vscode-sync-extensions save|install` fish function

## Neovim Key Bindings

- `<leader>sf` - Search files
- `<leader>sg` - Live grep
- `<leader>e` - Toggle file tree
- `gd` / `gr` - Go to definition / references
- `<C-h/j/k/l>` - Navigate splits (works across tmux panes)

## tmux Plugin Management

Add plugins to `.tmux.conf` with `set -g @plugin '...'`, then press `prefix + I` to install.

## macOS Note

VS Code settings are at `~/Library/Application Support/Code/User/` instead of `~/.config/Code/`. Symlink manually if needed.
