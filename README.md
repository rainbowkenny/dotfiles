# dotfiles

## New Mac setup

```sh
git clone git@github.com:rainbowkenny/dotfiles.git ~/dotfiles
~/dotfiles/bootstrap.sh
```

Safe to rerun. It installs the Command Line Tools, Homebrew, the packages in `Brewfile` (including Tailscale, which it opens for login if not connected), uv and oh-my-zsh, links `zsh/.zshrc`, `zsh/.zprofile` and `keymappings.sh` into `~`, and clones [vimrc](https://github.com/rainbowkenny/vimrc) as `~/.vim`.

Add a tool: append it to `Brewfile` and rerun `brew bundle --file=~/dotfiles/Brewfile`.

## Aliases

`keymappings.sh` holds the git/fzf aliases and functions shared by zsh and bash. Both `zsh/.zshrc` and `.bashrc` source `~/.keymappings.sh`.

## Bash (Linux)

```sh
ln -s ~/dotfiles/keymappings.sh ~/.keymappings.sh
ln -s ~/dotfiles/.bashrc ~/.bashrc
```
