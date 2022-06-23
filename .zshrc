PROFILE_STARTUP=false
if [[ "$PROFILE_STARTUP" == true ]]; then
    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
    PS4=$'%D{%M%S%.} %N:%i> '
    exec 3>&2 2>$HOME/tmp/startlog.$$
    setopt xtrace prompt_subst
fi

# Path to your oh-my-zsh installation.
export ZSH=${HOME}/.oh-my-zsh
export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true

# ZSH
ZSH_THEME="refined"
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

export PATH="$HOME/.cargo/bin:/usr/local/bin:/usr/local/opt/gettext/bin:$PATH"

# Better history
# Credits to https://coderwall.com/p/jpj_6q/zsh-better-history-searching-with-arrow-keys
# autoload -U up-line-or-beginning-search
# autoload -U down-line-or-beginning-search
# zle -N up-line-or-beginning-search
# zle -N down-line-or-beginning-search
# bindkey "^[[A" up-line-or-beginning-search # Up
# bindkey "^[[B" down-line-or-beginning-search # Down

# zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
plugins=(osx node npm tmux history-substring-search zsh-autosuggestions)

[ -f $ZSH/oh-my-zsh.sh ] && source $ZSH/oh-my-zsh.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# infocmp $TERM | sed 's/kbs=^[hH]/kbs=\\177/' > $TERM.ti
# tic $TERM.ti

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


if $(gls &>/dev/null)
then
  alias ls="gls -F --color"
  alias l="gls -lAh --color"
  alias ll="gls -l --color"
  alias la='gls -A --color'
fi


# NODE/NVM
export NODE_REPL_HISTORY_FILE=~/.node_repl

# ALIASES
alias reload!='. ~/.zshrc'
alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias pr="gh pr create --fill && gh pr view --web"
alias prd="git push && gh pr create --fill --draft && gh pr view --web"
alias vim=nvim
alias vimconfig="nvim ~/.config/nvim/init.vim"
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias code="code-insiders" # vscode

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

# thefuck
eval $(thefuck --alias)
# fuck () {
    # TF_HISTORY=$(fc -ln -10)
    # TF_CMD=$(
        # TF_ALIAS=fuck
        # TF_SHELL_ALIASES=$(alias)
        # TF_HISTORY=$TF_HISTORY
        # PYTHONIOENCODING=utf-8
        # thefuck THEFUCK_ARGUMENT_PLACEHOLDER $*
    # ) && eval $TF_CMD;
    # test -n "$TF_CMD" && print -s $TF_CMD
# }

if [[ "$PROFILE_STARTUP" == true ]]; then
    unsetopt xtrace
    exec 2>&3 3>&-
fi

eval "$(scmpuff init -s)"
eval "$(direnv hook zsh)"

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

eval "$(starship init zsh)"

