#!/usr/bin/env ruby

require 'fileutils'

def divider
  puts "-"*30
end

USER = ENV['USER']
HOME_DIR = ENV['HOME']
DOTFILES_SOURCE_PATH = "#{HOME_DIR}/Projects/dotfiles"

LINK_OR_UNLINK = !ARGV[0].nil? ? ARGV[0] : "link"

linkable_root_level_files = [
  'aliases',
  'gemrc',
  'gitconfig',
  'gitmessage',
  'hushlogin',
  'irbrc',
  'railsrc',
  'tmux.conf',
  'vimrc',
  'vimrc.bundles',
  'zshrc'
]

divider
puts "Welcome, #{USER}!"
puts "Home directory: #{HOME_DIR}"
divider

# puts "Bootstrapping directories we need..."
# FileUtils.mkdir_p ["#{HOME_DIR}/.config/nvm", "#{HOME_DIR}/.vim/colors", "#{HOME_DIR}/.testing-test-test"]
# divider

# puts "Syncing dotfiles..."
# divider

if LINK_OR_UNLINK == "link"
  linkable_root_level_files.each do |file_name|
    puts "Trying to sync: #{file_name}"

    if File.exists?("#{HOME_DIR}/.#{file_name}")
      puts "File #{file_name} exists, skipping..."
      puts ""
    else
      FileUtils.ln_s "#{DOTFILES_SOURCE_PATH}/#{file_name}", "#{HOME_DIR}/.#{file_name}"
      puts "File #{HOME_DIR}/.#{file_name} synced!"
    end
  end
elsif LINK_OR_UNLINK == "unlink"
  puts "Unlinking..."

  linkable_root_level_files.each do |file_name|
    FileUtils.rm "#{HOME_DIR}/.#{file_name}" if File.exists?("#{HOME_DIR}/.#{file_name}")
    puts "Unlinked #{HOME_DIR}/.#{file_name}"
  end
else
  puts "Invalid argument. Please use 'link' or 'unlink'."
end
