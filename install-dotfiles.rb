#!/usr/bin/env ruby

require 'fileutils'

USER = ENV['USER'].freeze
HOME_DIR = ENV['HOME'].freeze
DOTFILES_SOURCE_PATH = "#{HOME_DIR}/Projects/dotfiles".freeze

INSTALL_OR_UNINSTALL = (!ARGV[0].nil? ? ARGV[0] : "install").freeze

linkable_root_level_files = [
  'aliases',
  'gemrc',
  'gitconfig',
  'gitmessage',
  'irbrc',
  'railsrc',
  'tmux.conf',
  'vimrc',
  'vimrc.bundles',
  'zshrc',
  'tool-versions'
]

def installing?
  INSTALL_OR_UNINSTALL == "install"
end

class String
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
  def yellow;          "\e[33m#{self}\e[0m" end
  def blue;           "\e[34m#{self}\e[0m" end

  def bold;           "\e[1m#{self}\e[22m" end
end

def divider
  puts "-"*50
end

def touch_files
  touchable_files = ['aliases.local','hushlogin','env-vars']

  puts ""
  divider
  puts "Touching files to ensure they exist...".blue.bold

  touchable_files.each do |file|
    FileUtils.touch("#{HOME_DIR}/.#{file}")
    puts "---> Touched: #{HOME_DIR}/.#{file}".green
  end
  divider
end

def install_oh_my_zsh_themes
  puts "Installing Oh my ZSH Theme...".blue.bold
  if File.exists?("#{HOME_DIR}/.oh-my-zsh/custom/themes/afomera.zsh-theme")
    puts "---> afomera.zsh-theme already installed.".yellow
  else
    FileUtils.mkdir_p("#{HOME_DIR}/.oh-my-zsh/custom/themes")
    FileUtils.cp("#{DOTFILES_SOURCE_PATH}/oh-my-zsh/custom/themes/afomera.zsh-theme", "#{HOME_DIR}/.oh-my-zsh/custom/themes")
    puts "---> Installed afomera.zsh-theme".green
  end
end

def install_bin_functions
  puts ""
  puts "Installing .bin/ functions...".blue.bold
  if File.exists?("#{HOME_DIR}/.bin/tat")
    puts "---> .bin/tat already installed.".yellow
  else
    FileUtils.mkdir_p("#{HOME_DIR}/.bin")
    FileUtils.cp("#{DOTFILES_SOURCE_PATH}/bin/tat", "#{HOME_DIR}/.bin")
    puts "---> Installed .bin/tat".green
  end
end

def install_ssh_config
  puts ""
  puts "Installing SSH Configuration...".blue.bold
  if File.exists?("#{HOME_DIR}/.ssh/config")
    puts "---> SSH Configuration already installed.".yellow
  else
    FileUtils.mkdir_p("#{HOME_DIR}/.ssh")
    FileUtils.cp("#{DOTFILES_SOURCE_PATH}/.ssh/config", "#{HOME_DIR}/.ssh")
    puts "---> Installed SSH Default Config".green
  end
end

def install_vim_color_theme
  puts ""
  puts "Installing VIM Color Theme...".blue.bold
  if File.exists?("#{HOME_DIR}/.vim/colors/monokai.vim")
    puts "---> Monokai Vim Color Theme already installed.".yellow
  else
    FileUtils.mkdir_p("#{HOME_DIR}/.vim/colors")
    FileUtils.cp("#{DOTFILES_SOURCE_PATH}/vim/colors/monokai.vim", "#{HOME_DIR}/.vim/colors")
    puts "---> Installed Monokai Vim Color Theme".green
  end
end

def install_neovim_init_file
  puts ""
  puts "Installing neovim init...".blue.bold
  if File.exists?("#{HOME_DIR}/.config/nvim/init.vim")
    puts "---> NeoVim configuration init script already installed.".yellow
  else
    FileUtils.mkdir_p("#{HOME_DIR}/.config/nvim")
    FileUtils.cp("#{DOTFILES_SOURCE_PATH}/.config/nvim/init.vim", "#{HOME_DIR}/.config/nvim")
    puts "---> Installed NeoVim configuration init script".green
  end
end

# ------------------------------------------------------------------------------------------------------------------
# Welcome Message

divider
puts "Welcome, #{USER}!".green
puts "Home directory: #{HOME_DIR}".blue
divider

# ------------------------------------------------------------------------------------------------------------------
# Linking / Installation

if installing?
  touch_files
  puts ""
  divider
  install_oh_my_zsh_themes
  install_bin_functions
  install_ssh_config
  install_vim_color_theme
  install_neovim_init_file
  divider

  puts ""
  divider
  puts "Linking dotfiles...".blue.bold

  linkable_root_level_files.each do |file_name|
    if File.exists?("#{HOME_DIR}/.#{file_name}")
      puts "---> File #{HOME_DIR}/.#{file_name} exists, skipping...".yellow
    else
      FileUtils.ln_s "#{DOTFILES_SOURCE_PATH}/#{file_name}", "#{HOME_DIR}/.#{file_name}"
      puts "---> File #{HOME_DIR}/.#{file_name} synced!".green
    end
  end
  divider
end

# ------------------------------------------------------------------------------------------------------------------
# Unlinking / Uninstallation

def uninstalling?
  INSTALL_OR_UNINSTALL == "uninstall"
end

if uninstalling?
  puts "Unlinking files...".blue.bold

  linkable_root_level_files.each do |file_name|
    FileUtils.rm "#{HOME_DIR}/.#{file_name}" if File.exists?("#{HOME_DIR}/.#{file_name}")
    puts "---> Unlinked #{HOME_DIR}/.#{file_name}".green
  end
end

# ------------------------------------------------------------------------------------------------------------------
# Goodbye Message

puts ""
divider
puts "All finished, #{USER}!".green
puts "Restart your terminal to pick up the changes.".blue.bold
divider
