## Sync dotfiles to new machine

```
cd ~
git clone git@github.com:ehsanul/dotfiles.git
mv dotfiles .dotfiles
brew install rcm
rcup -v -x README.md
```
