# My dotfiles

Follow instructions below

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

- [ ] Install [tmux plugin manager](https://github.com/tmux-plugins/tpm) before you start tmux
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
Then when inside of `tmux`, `<prefix> + I` to install the `tmux` plugins.

- [ ] Configure MacOS preferences
```bash
./macos-defaults.sh
```

- [ ] Install the [catppuccin theme](https://github.com/catppuccin/bat) for `bat`
```bash
mkdir -p "$(bat --config-dir)/themes"
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Frappe.tmTheme
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
bat cache --build
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
