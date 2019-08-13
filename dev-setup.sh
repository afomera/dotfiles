#!/bin/bash

# Installs Homebrew software.
if ! command -v brew > /dev/null; then
  ruby -e "$(curl --location --fail --silent --show-error https://raw.githubusercontent.com/Homebrew/install/master/install)"
  export PATH="/usr/local/bin:$PATH"
  printf "export PATH=\"/usr/local/bin:$PATH\"\n" >> $HOME/.bash_profile
fi

echo "----------------------------"
echo "Setting up dotfile defaults"
echo "----------------------------"

# Setup ruby gemrc file
printf "%s\n" "---" > "$HOME/.gemrc"
printf "%s\n" "gem: --no-document" >> "$HOME/.gemrc"
echo "Setup .gemrc dotfile"

# Setup railsrc file
printf "%s\n" "--database=postgresql" > "$HOME/.railsrc"
echo "Setup .railsrc dotfile"

# Setup .ssh/config
printf "%s\n" "Host *
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
" > "$HOME/.ssh/config"
echo "Setup .ssh/config"

echo "----------------------------"
echo "Setting up git defaults"
echo "----------------------------"
git config --global color.ui true
git config --global user.name "Andrew Fomera"
git config --global user.email "andrew@zerlex.net"
echo "Setup git name and email"

echo "----------------------------"
echo "Setting up Mac defaults"
echo "----------------------------"

printf "%s\n" "System - Disable boot sound effects."
sudo nvram SystemAudioVolume=" "

printf "%s\n" "System - Avoid creating .DS_Store files on network volumes."
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

printf "%s\n" "System - Expand save panel by default."
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

printf "%s\n" "System - Disable 'Are you sure you want to open this application?' dialog."
defaults write com.apple.LaunchServices LSQuarantine -bool false

printf "%s\n" "System - Disable window resume system-wide."
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false

# Setup Mac App System defaults for Finder
printf "%s\n" "Finder - Show hidden files."
defaults write com.apple.finder AppleShowAllFiles -bool true

printf "%s\n" "Finder - Show filename extensions."
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

printf "%s\n" "Finder - Show path bar."
defaults write com.apple.finder ShowPathbar -bool true

printf "%s\n" "Finder - Show status bar."
defaults write com.apple.finder ShowStatusBar -bool true

printf "%s\n" "Finder - Display full POSIX path as window title."
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

printf "%s\n" "Finder - Use list view in all Finder windows."
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Setup Mac - Safari Defaults
printf "%s\n" "Safari - Enable debug menu."
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

printf "%s\n" "Safari - Enable the Develop menu and the Web Inspector."
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

printf "%s\n" "Safari - Add a context menu item for showing the Web Inspector in web views."
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

printf "%s\n" "Safari - Disable sending search queries to Apple.."
defaults write com.apple.Safari UniversalSearchEnabled -bool false

# Setup Mac - Misc Apple stuff
printf "%s\n" "TextEdit - Use plain text mode for new documents."
defaults write com.apple.TextEdit RichText -int 0

printf "%s\n" "TextEdit - Open and save files as UTF-8 encoding."
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

printf "%s\n" "Game Center - Disable Game Center."
defaults write com.apple.gamed Disabled -bool true

printf "%s\n" "App Store - Enable the WebKit Developer Tools in the Mac App Store."
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

printf "%s\n" "App Store - Enable Debug Menu in the Mac App Store."
defaults write com.apple.appstore ShowDebugMenu -bool true

printf "%s\n" "Mail - Copy email addresses as 'foo@example.com' instead of 'Foo Bar <foo@example.com>'."
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

printf "%s\n" "Mail - Disable send animation."
defaults write com.apple.mail DisableSendAnimations -bool true

printf "%s\n" "Mail - Disable reply animation."
defaults write com.apple.mail DisableReplyAnimations -bool true