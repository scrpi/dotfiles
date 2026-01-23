# My dotfiles

## Requirements

```
sudo apt install stow
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

## Installing Fish Shell

**Ubuntu/Debian:**
```bash
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install fish
```

**macOS:**
```bash
brew install fish
```

To set fish as your default shell:
```bash
chsh -s $(which fish)
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

## Installing Alacritty

**Ubuntu/Debian:**
```bash
sudo add-apt-repository ppa:aslatter/ppa
sudo apt update
sudo apt install alacritty
```

**macOS:**
```bash
brew install --cask alacritty
```

### Alacritty terminfo

```bash
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

