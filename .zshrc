# clone antidote if necessary
[[ -e ~/.antidote ]] || git clone https://github.com/mattmc3/antidote.git ~/.antidote

# keep PATH entries unique
typeset -U path

(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"

# Enable the "new" completion system (compsys).
# autoload -Uz compinit && compinit
# [[ ~/.zcompdump.zwc -nt ~/.zcompdump ]] || zcompile -R -- ~/.zcompdump{.zwc,}

# ZSH
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

export PATH="$HOME/.cargo/bin:/usr/local/opt/gettext/bin:$PATH:/usr/local/bin"
export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true

# source antidote
. ~/.antidote/antidote.zsh

# generate and source plugins from ~/.zsh_plugins.txt
antidote load

# after antidote so plugin completions (zsh-completions) are on fpath
autoload -Uz compinit && compinit

# Homebrew (macOS or Linux); before fzf so brew's fzf is on PATH
for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  [[ -x $brew_bin ]] && eval "$($brew_bin shellenv zsh)" && break
done
unset brew_bin

# fzf keybindings (Ctrl-R, Ctrl-T, Alt-C) and completion
if [[ -f ~/.fzf.zsh ]]; then
  source ~/.fzf.zsh
elif (( $+commands[fzf] )) && fzf --zsh &>/dev/null; then
  source <(fzf --zsh)  # fzf >= 0.48
else
  # older fzf: scripts ship in a distro-specific location
  for fzf_dir in /usr/share/doc/fzf/examples /usr/share/fzf ${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/opt/fzf/shell}; do
    if [[ -f $fzf_dir/key-bindings.zsh ]]; then
      source $fzf_dir/key-bindings.zsh
      [[ -f $fzf_dir/completion.zsh ]] && source $fzf_dir/completion.zsh
      break
    fi
  done
  unset fzf_dir
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

setopt NO_BG_NICE # don't nice background tasks
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt HIST_VERIFY
setopt EXTENDED_HISTORY # add timestamps to history
setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD
setopt IGNORE_EOF
setopt SHARE_HISTORY  # write history incrementally and share it across sessions
setopt HIST_IGNORE_ALL_DUPS  # don't record dupes in history
setopt HIST_REDUCE_BLANKS
# don't expand aliases _before_ completion has finished
#   like: git comm-[tab]
setopt complete_aliases

bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word
bindkey '^[[5D' beginning-of-line
bindkey '^[[5C' end-of-line
bindkey '^[[3~' delete-char
bindkey '^?' backward-delete-char
bindkey '^u' backward-kill-line

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
# Debian's /etc/zsh/zshrc enables keypad (smkx) mode, so arrows send ^[OA/^[OB
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# NODE/NVM
export NODE_REPL_HISTORY_FILE=~/.node_repl

# ALIASES
alias ls="ls --color"
alias reload!='. ~/.zshrc'
alias zshconfig="nvim ~/.zshrc"
alias pr="gh pr create --fill-first && gh pr view --web"
alias prd="git push && gh pr create --fill-first --draft && gh pr view --web"
alias vim=nvim
alias vimconfig="nvim ~/.config/nvim/init.lua"
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# The rest of my fun git aliases
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"

# Remove `+` and `-` from start of diff lines; just rely upon color.
alias gd='git diff --color | sed "s/^\([^-+ ]*\)[-+ ]/\\1/" | less -r'

alias gc='git commit'
alias gco='git checkout'
alias gb='git branch'
# alias gs='git status -sb' # upgrade your git if -sb breaks for you. it's fun.
alias gap='git add -p'
alias gp="git pull"
alias gl="git lg"

# fzf search local branches
fbr() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
  fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //")
}

# VIM
export NEOVIM_JS_DEBUG=/tmp/nvim_js_debug
export EDITOR='nvim'

alias yarnconflict="git checkout origin/master -- yarn.lock && yarn"
alias gpm='git checkout main && comm -12 <(git branch | sed "s/ *//g") <(git remote prune origin | sed "s/^.*origin\///g") | xargs -r git branch -D'

export NODE_OPTIONS=--max_old_space_size=8192
export MANPAGER='nvim +Man!'
# export BAT_THEME='Monokai Extended'
export BAT_THEME='Catppuccin Frappe'
export PATH="$PATH:$HOME/.bin"

[ -f ~/.sentryrc ] && source ~/.sentryrc

# Load plugins.
(( ${+commands[scmpuff]} )) && eval "$(scmpuff init -s)"

# thefuck
(( ${+commands[thefuck]} )) && eval $(thefuck --alias)

export FZF_DEFAULT_OPTS=" \
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

export PATH="$HOME/code/sentry:$PATH"
export SLACK_DEVELOPER_MENU=true
# export XDG_RUNTIME_DIR=$HOME/.local/run # idk this was added for some Sentry issue, may not be needed any more
export PATH="$HOME/.local/share/sentry-devenv/bin:$PATH"

# opencode
export PATH=$HOME/.opencode/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Vite+ bin (https://viteplus.dev)
. "$HOME/.vite-plus/env"

# Pi -- reachable via the vp shim at ~/.vite-plus/bin/pi, which is already on
# PATH. Do not prepend a js_runtime bin dir here: it pins one Node for the
# whole machine ahead of vp's per-directory shims (was 24.19.0, which made
# codbuilds ignore its own .nvmrc pin of 26.8.1).

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

# machine-local settings and secrets (untracked)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# dedupe PATH once everything above has added to it
path=($path)
