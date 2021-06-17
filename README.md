# My dotfiles

## Usage

```bash
git init --bare $HOME/.dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
config config status.showUntrackedFiles no
```


```
config status
config add .zshrc
config commit -m "Add .zshrc"
config push
```


See https://www.atlassian.com/git/tutorials/dotfiles for more information
