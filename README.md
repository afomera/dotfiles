## My dotfiles

These are my dotfiles... WIP but trying to organize my files across
multiple computers has finally frustrated me enough to fix this mess.

## Software Used

**Editors**

- [Visual Studio Code](https://code.visualstudio.com)
- Vim - Some basic configurations are currently added (Monokai theme)
- Neovim - because why not have two vims?

**Terminal**

- [iTerm 2](https://www.iterm2.com/)
- [Oh my zsh](https://github.com/robbyrussell/oh-my-zsh)
- Tmux - `brew install tmux`
- Tmuxinator - `brew install tmuxinator`

**Package Management**

- [Homebrew](http://brew.sh)

## ZSH AutoSuggestions

I occasionally use zsh-autosuggestions. I follow the instructions at:
https://github.com/zsh-users/zsh-autosuggestions

for the oh-my-zsh installation.

## Installing iTerm Theme

1. Launch iTerm 2. Get the latest version at iterm2.com
2. Type CMD+i (⌘+i)
3. Navigate to Colors tab
4. Click on Load Presets
5. Click on Import
6. Select the .itermcolors file(s) of the scheme(s) you'd like to use
7. Click on Load Presets and choose a color scheme

# vim-plug

https://github.com/junegunn/vim-plug

Installation for vim:

```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

Installation for neovim:

```
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```
