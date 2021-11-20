# .dotfiles

Opinionated, and probably not the way you like 'em.

## Getting started

**New Computer?**

- Run `install-terminal-tools.sh`, it will install Homebrew, Oh my zsh, zsh-autosuggestions and ASDF along with the ruby and nodejs plugins.

Then, we can start customizing on top of that platform.

## Highlights

**Oh my ZSH!**

- ~/.zshrc default configuration with a change so the paths will work regardless of computer username
- Also includes the code to pick up changes in the ~/.bin folder we make, and our ~/.aliases and ~/.env-vars files.

**Vim**

_Requires Neovim_

- ~/.vimrc will auto-install vim-plug
- ~/.vimrc/colors/monokai.vim -- theme for the monokai syntax highlighting.
- plugins live in the ~/.vimrc.bundles file
- Leader key has been re-mapped to <space>

**Tmux**

- ~/.tmux.conf - sets the tmux settings, still using the default cntrl+b keys.

**Terminal**

- ~/.hushlogin to quiet the iTerm2 login message
- ~/.aliases.local is where we put system specific overrides (ie for work projects etc)
- ~/.env-vars for putting ENVs we need for other things.

**Rails/Ruby specific things**

- ~/.gemrc will make it so we don't install documentation for rubygems
- ~/.railsrc ensures we always use postgresql for our db for rails apps unless we specify different
- ~/.irbrc helps tell us when we're in a safe Rails console session or if we're in production (not pry compatible)

**Git**

- ~/.gitconfig - for the usual git setups, as well as the name + email of Git author
- ~/.gitmessage - for the default prompt for git commit messages

---

# Legacy readme

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
