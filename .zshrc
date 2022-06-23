# clone antidote if necessary
[[ -e ~/.antidote ]] || git clone https://github.com/mattmc3/antidote.git ~/.antidote

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

export PATH="$HOME/.cargo/bin:/usr/local/bin:/usr/local/opt/gettext/bin:$PATH"
export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true


autoload -Uz compinit && compinit

# source antidote
. ~/.antidote/antidote.zsh

# generate and source plugins from ~/.zsh_plugins.txt
antidote load

if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
else
  (( $+commands[brew] )) && $(brew --prefix)/opt/fzf/install
fi

# Load plugins.
eval "$(scmpuff init -s)"

# thefuck
eval $(thefuck --alias)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

setopt NO_BG_NICE # don't nice background tasks
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt HIST_VERIFY
setopt SHARE_HISTORY # share history between sessions ???
setopt EXTENDED_HISTORY # add timestamps to history
setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD
setopt IGNORE_EOF
setopt APPEND_HISTORY # adds history
setopt INC_APPEND_HISTORY SHARE_HISTORY  # adds history incrementally and share it across sessions
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

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line


# NODE/NVM
export NODE_REPL_HISTORY_FILE=~/.node_repl

# ALIASES
alias reload!='. ~/.zshrc'
alias zshconfig="nvim ~/.zshrc"
alias pr="gh pr create --fill && gh pr view --web"
alias prd="git push && gh pr create --fill --draft && gh pr view --web"
alias vim=nvim
alias vimconfig="nvim ~/.config/nvim/init.vim"
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# The rest of my fun git aliases
alias gl='git pull --prune'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"

# Remove `+` and `-` from start of diff lines; just rely upon color.
alias gd='git diff --color | sed "s/^\([^-+ ]*\)[-+ ]/\\1/" | less -r'

alias gc='git commit'
alias gco='git checkout'
alias gcb='git copy-branch-name'
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
alias gprunemerged='git checkout master && comm -12 <(git branch | sed "s/ *//g") <(git remote prune origin | sed "s/^.*origin\///g") | xargs -L1 -J % git branch -D %'
alias gpm='git checkout main && comm -12 <(git branch | sed "s/ *//g") <(git remote prune origin | sed "s/^.*origin\///g") | xargs -L1 -J % git branch -D %'

export NODE_OPTIONS=--max_old_space_size=8192
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export MANPAGER='nvim +Man!'
export BAT_THEME='Monokai Extended'
export PATH="$PATH:/Users/billy/.bin"

[ -f ~/.sentryrc ] && source ~/.sentryrc

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/billy/Downloads/google-cloud-sdk 2/path.zsh.inc' ]; then . '/Users/billy/Downloads/google-cloud-sdk 2/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/billy/Downloads/google-cloud-sdk 2/completion.zsh.inc' ]; then . '/Users/billy/Downloads/google-cloud-sdk 2/completion.zsh.inc'; fi

