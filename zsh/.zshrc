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

# ── Git aliases ────────────────────────────────────────────────────────────────
alias gl='git log --oneline -n 10 --graph'
alias gs='git status'
alias gr='git remote -v'
alias gd='git diff'
alias gb='git branch'
alias gc='git commit -m '
alias gp='git push'
alias gpu='git push -u origin $(git rev-parse --abbrev-ref HEAD)'
alias gpf='git push -f'
alias gaa='git add .'
alias gau='git add -u'
alias gca='git commit --amend --no-edit'
alias grc='git rebase --continue'
alias gro='git rebase origin/main'
alias gsu='git submodule update --init --recursive'

alias gbf='git branch -a|fzf'
alias gbrf='git branch -r|fzf'
alias gaf='git add $(git diff --name-only|fzf --multi)'
alias gdf='git diff $(git diff --name-only|fzf)'
alias gdsf='git diff --cached $(git diff --cached --name-only|fzf)'
alias gsf='git show $(git log --oneline|fzf|cut -c -6)'
alias gsrf='git show $(git log --oneline $(git branch -r|fzf --sync)|fzf --sync|cut -c -6)'
alias gcbf='git checkout $(git branch -a|fzf)'
alias gcfr='git checkout $(git ls-tree -r $(git branch -r|fzf --sync) --name-only|fzf --sync)'
alias checkout='git checkout $(gb|fzf)'
alias cherrypick='git cherry-pick $(git log --reflog --oneline|fzf --multi|cut -c -6)'
alias grf='git rebase $(git branch -a|fzf)'
alias grif='git rebase -i $(git log --oneline|fzf|cut -c -6)~'

alias unstageAll='git reset HEAD'
alias unstageFile='git restore --staged $(git diff --cached --name-only|fzf)'
alias revA='git checkout HEAD .'
alias revF='git diff --name-only -z | fzf --multi --read0 --print0 | xargs -0 git restore'
alias fetchfile='selected_branch=$(git branch -r | fzf) && selected_files=$(git ls-tree -r --name-only $selected_branch | fzf --multi --preview "echo {} && git show $selected_branch:{}") && git fetch origin && for file in $selected_files; do git checkout $selected_branch -- "$file"; done'

# ── Misc aliases ───────────────────────────────────────────────────────────────
alias sz='source ~/.zshrc'
alias ep='echo $PATH'

# ── Functions ──────────────────────────────────────────────────────────────────
gw() {
  local branch="${1:?Usage: gw <branch>}"
  local worktree_path="$(dirname "$PWD")/$branch"
  local git_common_dir
  git_common_dir="$(git rev-parse --git-common-dir)"

  git show-ref --verify --quiet "refs/heads/$branch" || git branch "$branch"
  git worktree add "$worktree_path" "$branch"

  git submodule foreach --quiet 'echo $sm_path' | while read -r sm_path; do
    local sm_git_dir="$git_common_dir/modules/$sm_path"
    local target="$worktree_path/$sm_path"
    if [ ! -d "$sm_git_dir" ]; then
      echo "  Skipping submodule $sm_path (not initialized)"
      continue
    fi
    local sm_commit
    sm_commit=$(git ls-files --stage "$sm_path" | awk '{print $2}')
    echo "  Adding submodule worktree: $sm_path @ $sm_commit"
    git -C "$sm_git_dir" worktree add --detach "$target" "$sm_commit"
  done

  cd "$worktree_path"
}

gwrf() {
  local wt
  wt=$(git worktree list | grep -v '(bare)' | fzf --height=40% --reverse | awk '{print $1}') && [ -n "$wt" ] && git worktree remove --force "$wt"
}

command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
export PATH=$PATH:$HOME/.maestro/bin

alias cm='CLAUDE_CONFIG_DIR=$HOME/.claude-personal claude --dangerously-skip-permissions'
