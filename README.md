# My dotfiles

## Requirements

```
sudo apt install stow
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

## Installation
```
cd ~
git clone git@github.com:scrpi/dotfiles.git
cd dotfiles
stow .
```

## Installing tmux plugins

1. Add new plugin to `~/.tmux.conf` with `set -g @plugin '...'`
2. Press `prefix` + <kbd>I</kbd> (capital i, as in **I**nstall) to fetch the plugin.

## Alacritty terminfo

```
curl -sSL https://raw.githubusercontent.com/alacritty/alacritty/master/extra/alacritty.info | tic -x -
```

## VS Code

Extensions are stored in `.config/Code/extensions.txt`. Use the fish function to manage them:

```bash
# Save current extensions to dotfiles
vscode-sync-extensions save

# Install extensions from dotfiles on a new machine
vscode-sync-extensions install
```

**Note:** On macOS, VS Code stores settings in `~/Library/Application Support/Code/User/`, not `~/.config/Code/`. You may need to manually merge settings or symlink:

```bash
ln -sf ~/dotfiles/.config/Code/User/settings.json ~/Library/Application\ Support/Code/User/settings.json
```

