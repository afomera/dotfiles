#!/usr/bin/env ruby

require 'fileutils'

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

USER = ENV['USER']
HOME_DIR = ENV['HOME']
DOTFILES_SOURCE_PATH = "#{HOME_DIR}/Projects/dotfiles"

LINK_OR_UNLINK = !ARGV[0].nil? ? ARGV[0] : "link"

touchable_files = [
  'aliases.local',
  'hushlogin'
]

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
  'zshrc'
]

divider
puts "Welcome, #{USER}!".green
puts "Home directory: #{HOME_DIR}".blue
divider

puts ""

divider
puts "Touching files to ensure they exist...".blue.bold

touchable_files.each do |file|
  FileUtils.touch("#{HOME_DIR}/.#{file}")
  puts "---> Touched: #{HOME_DIR}/.#{file}".green
end
divider

puts ""
divider
puts "Installing VIM Color Theme...".blue.bold
if File.exists?("#{HOME_DIR}/.vim/colors/monokai.vim")
  puts "---> Monokai Vim Color Theme already installed.".yellow
else
  FileUtils.mkdir_p("#{HOME_DIR}/.vim/colors")
  FileUtils.cp("#{DOTFILES_SOURCE_PATH}/vim/colors/monokai.vim", "#{HOME_DIR}/.vim/colors/")
  puts "---> Installed Monokai Vim Color Theme".green
end
divider


puts ""
divider
puts "Installing neovim init...".blue.bold
if File.exists?("#{HOME_DIR}/.config/nvim/init.vim")
  puts "---> NeoVim configuration init script already installed...".yellow
else
  FileUtils.mkdir_p("#{HOME_DIR}/.config/nvim")
  FileUtils.cp("#{DOTFILES_SOURCE_PATH}/.config/nvim/init.vim", "#{HOME_DIR}/.config/nvim")
  puts "---> Installed NeoVim configuration init script".green
end
divider

if LINK_OR_UNLINK == "link"
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
elsif LINK_OR_UNLINK == "unlink"
  puts "Unlinking files...".blue.bold

  linkable_root_level_files.each do |file_name|
    FileUtils.rm "#{HOME_DIR}/.#{file_name}" if File.exists?("#{HOME_DIR}/.#{file_name}")
    puts "---> Unlinked #{HOME_DIR}/.#{file_name}".green
  end
else
  puts "Invalid argument. Please use 'link' or 'unlink'."
end
