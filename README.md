# My dotfiles

## Usage

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/billyvg/dotfiles/main/.dotfiles-bootstrap.sh)"
```

### My Checklist

- [ ] Install dotfiles (this will prompt you to install Xcode CLI tools)
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/billyvg/dotfiles/main/.dotfiles-bootstrap.sh)"
```
- [ ] Install [homebrew](https://brew.sh)
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
- [ ] `brew bundle`
- [ ] Install node - make sure you use a recent version -- this is required before installing neovim plugins
```bash
volta install node@16
```
- [ ] Install [tmux plugin manager](https://github.com/tmux-plugins/tpm) before you start tmux
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```


### Manual
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
