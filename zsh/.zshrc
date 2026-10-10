# OPENSPEC: shell completions fpath (compinit handled by oh-my-zsh)
fpath=("$HOME/.oh-my-zsh/custom/completions" $fpath)

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="ys"

# Which plugins would you like to load?
plugins=(git)

ZSH_DISABLE_COMPFIX=true
source $ZSH/oh-my-zsh.sh


# Set up fzf key bindings and fuzzy completion
command -v fzf >/dev/null && source <(fzf --zsh)

# PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"

# Google Cloud SDK
if [ -f '/opt/homebrew/share/google-cloud-sdk/path.zsh.inc' ]; then . '/opt/homebrew/share/google-cloud-sdk/path.zsh.inc'; fi
if [ -f '/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc' ]; then . '/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc'; fi

# bun completions
export BUN_INSTALL="$HOME/.bun"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

[ -f "$HOME/.keymappings.sh" ] && source "$HOME/.keymappings.sh"
alias sz='source ~/.zshrc'

command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
export PATH=$PATH:$HOME/.maestro/bin

alias cm='CLAUDE_CONFIG_DIR=$HOME/.claude-personal claude --dangerously-skip-permissions'
