#!/bin/bash

# Install (and update) vim plugins for vim-plug and close vim
nvim +PlugInstall +PlugUpdate +qall

echo "NeoVim installed the plugins!"
