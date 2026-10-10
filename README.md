# dotfiles

## New Mac setup

```sh
git clone git@github.com:rainbowkenny/dotfiles.git ~/dotfiles
~/dotfiles/bootstrap.sh
```

Safe to rerun. It installs the Command Line Tools, Homebrew, the packages in `Brewfile` (including Tailscale, which it opens for login if not connected), uv and oh-my-zsh, links `zsh/.zshrc` and `zsh/.zprofile` into `~`, and clones [vimrc](https://github.com/rainbowkenny/vimrc) as `~/.vim`.

Add a tool: append it to `Brewfile` and rerun `brew bundle --file=~/dotfiles/Brewfile`.

## Legacy bash setup

Deprecated, kept for reference:

```sh
cat keymappings.sh >> ~/.bashrc
```
