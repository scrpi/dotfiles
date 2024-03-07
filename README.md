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

