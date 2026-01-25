echo "Backing up pre-existing dot files.";
cp -R .config .config-backup

git clone --bare https://github.com/billyvg/dotfiles $HOME/.dotfiles
function config {
   /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}
config checkout
if [ $? = 0 ]; then
        echo "Checked out config.";
fi;
config config status.showUntrackedFiles no
