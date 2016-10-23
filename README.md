## My dotfiles

These are my dotfiles... WIP but trying to organize my files across
multiple computers has finally frustrated me enough to fix this mess.

## Software Used
**Editors**
- [Atom](http://atom.io)
- MacVim `brew install macvim`
  - [Janus (plugins)](https://github.com/carlhuda/janus)
      Install script: `curl -L https://bit.ly/janus-bootstrap | bash`

**Terminal**
- [iTerm 2](https://www.iterm2.com/)
- [Oh my zsh](https://github.com/robbyrussell/oh-my-zsh)

**Package Management**
- [Homebrew](http://brew.sh)

## General Notes
- Leader key for mvim defaults to \
- Switching between panes/windows in macvim is Ctrl-w-w
- Running shell commands in VIM - Esc (out of mode you're in to normal..)
  :!(command) for example typing :!touch
app/controllers/home_controller.rb will create a file like a normal
touch command.
- Selecting text and indenting: Enter visual mode (V) select the text
  (you can press `jj` and it'll select three lines and you can then
press > to indent or < to remove one set of indention.
- Auto-indenting all text: `(V) - Cmd+A - =`

## Installing iTerm Theme

1. Launch iTerm 2. Get the latest version at iterm2.com
2. Type CMD+i (⌘+i)
3. Navigate to Colors tab
4. Click on Load Presets
5. Click on Import
6. Select the .itermcolors file(s) of the scheme(s) you'd like to use
7. Click on Load Presets and choose a color scheme
