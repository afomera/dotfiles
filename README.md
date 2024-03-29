# .dotfiles

Opinionated, and probably not the way you like 'em. But... if you do, have at it!

- Homebrew
- Vim uses vim-plug for packages
- NeoVim (because GitHub Copilot), `vim` is aliased to `nvim` in the `.aliases` file, also uses ~/.vimrc configuration.
- Tmuxinator (because easier to script opening multiple tmux windows/panes)
- iTerm2

## Getting started

**New Computer?**

1. Clone this repo

   ```
   mkdir -p ~/Projects && cd ~/Projects && git clone git@github.com:afomera/dotfiles.git
   ```

2. Run the installation command for Terminal Tools

   ```
    cd ~/Projects/dotfiles && ./install-terminal-tools.sh
   ```

   It will install Homebrew, Oh my zsh, zsh-autosuggestions and ASDF along with the ruby and nodejs plugins.

3. Install main dependencies

   ```
     cd ~/Projects/dotfiles && ./install-dependencies.sh
   ```

   Installs a number of homebrew packages, but avoids installing redis or postgres.

4. Restart your Terminal, and install-dotfiles

   ```
     cd ~/Projects/dotfiles && ./install-dotfiles.rb
   ```

   This adds linked files to your local dotfiles clone, and will install the configuration files for NeoVim, SSH, tmux etc.

   If you need to uninstall... run: `cd ~/Projects/dotfiles && ./install-dotfiles.rb uninstall`

Then restart your Terminal and you're off to install your packages from your specific projects.

**Quitting your job? Going to live on a farm instead of coding?**

```
  cd ~/Projects/dotfiles && ./install-dotfiles.rb uninstall
```

## Highlights about what each file does

**Oh my ZSH!**

- ~/.zshrc default configuration with a change so the paths will work regardless of computer username
- Also includes the code to pick up changes in the ~/.bin folder we make, and our ~/.aliases and ~/.env-vars files.

**Vim**

_Requires Neovim_

- ~/.vimrc will auto-install vim-plug
- ~/.vimrc/colors/monokai.vim -- theme for the monokai syntax highlighting.
- plugins live in the ~/.vimrc.bundles file
- Leader key has been re-mapped to the `space` button

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

## Additional Software Used (install manually!)

**Editors**

- [Visual Studio Code](https://code.visualstudio.com)

**Terminal**

- [iTerm 2](https://www.iterm2.com/)

## Installing iTerm Theme

1. Launch iTerm 2. Get the latest version at iterm2.com
2. Type CMD+i (⌘+i)
3. Navigate to Colors tab
4. Click on Load Presets
5. Click on Import
6. Select the .itermcolors file(s) of the scheme(s) you'd like to use
7. Click on Load Presets and choose a color scheme
