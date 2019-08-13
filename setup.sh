#!/bin/bash

# This sets up the base of my machine
# Other scripts will install more language specific software

# Change these if you wish to change something
export GIT_AUTHOR_NAME="Andrew Fomera"
export GIT_AUTHOR_EMAIL="andrew@zerlex.net"

export MAC_OS_NAME="andrewfomera-mpb"
export MAC_OS_LABEL="Andrew Fomera - MPB"

export SCREENSHOT_LOCATION="$HOME/Library/Mobile\ Documents/com~apple~CloudDocs/Screenshots"

# Set DOTFILES var we can use when we copy things around
DOTFILES=$(pwd -P)

# Ask for password upfront
sudo -v

echo $DOTFILES

# Purple Text output
info() {
 printf "\033[00;34m$@\033[0m\n"
}

installFonts() {
  info "Installing Fonts"

   if [ "$(uname)" == "Darwin" ]; then
        fonts="$HOME/Library/Fonts"
    elif [ "$(uname)" == "Linux" ]; then
        fonts=~/.fonts
        mkdir -p "$fonts"
    fi

    find "$DOTFILES/fonts/" -name "*.[o,t]tf" -type f | while read -r file
    do
        cp -v "$file" "$fonts"
    done
}

# Comment out installing fonts for now
installFonts

# Installs development requirements.
if ! command -v xcode-select > /dev/null; then
  printf "Installing Xcode CLI tools...\n"
  xcode-select --install

  printf "%s\n" "💡 ALT+TAB to view and accept Xcode license window."
  read -p "Have you completed the Xcode CLI tools install (y/n)? " xcode_response
  if [[ "$xcode_response" != "y" ]]; then
    printf "ERROR: Xcode CLI tools must be installed before proceeding.\n"
    exit 1
  fi
fi

# Installs Homebrew software.
if ! command -v brew > /dev/null; then
  ruby -e "$(curl --location --fail --silent --show-error https://raw.githubusercontent.com/Homebrew/install/master/install)"
  export PATH="/usr/local/bin:$PATH"
  printf "export PATH=\"/usr/local/bin:$PATH\"\n" >> $HOME/.bash_profile
fi

echo "-------------------------------"
echo "Installing dependencies via Homebrew"
echo "-------------------------------"

brew install mas
brew install imagemagick

echo "-------------------------------"
echo "Setting up computer defaults"
echo "-------------------------------"

printf "Setting system label and name...\n"
sudo scutil --set ComputerName $MAC_OS_LABEL
sudo scutil --set HostName $MAC_OS_NAME
sudo scutil --set LocalHostName $MAC_OS_NAME
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $MAC_OS_NAME

echo "-------------------------------"
echo "Setting up dotfile defaults"
echo "-------------------------------"

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

printf "%s\n" "" > "$HOME/.hushlogin"
echo "Disabled iTerm last logged in message (.hushlogin)"

echo "-------------------------------"
echo "Setting up git defaults"
echo "-------------------------------"
git config --global color.ui true
git config --global user.name "$GIT_AUTHOR_NAME"
git config --global user.email "$GIT_AUTHOR_EMAIL"
git config --global core.excludesfile "$HOME/.gitignore_global"

echo "-------------------------------"
echo "Setting up Mac defaults"
echo "-------------------------------"

printf "%s\n" "System - Disable boot sound effects."
sudo nvram SystemAudioVolume=" "

printf "%s\n" "System - Disable Menu Bar Transparency"
defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false;


printf "%s\n" "System - Menu bar: hide the Time Machine, Volume, and User icons"
for domain in ~/Library/Preferences/ByHost/com.apple.systemuiserver.*; do
  defaults write "${domain}" dontAutoLoad -array \
    "/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
    "/System/Library/CoreServices/Menu Extras/Volume.menu" \
    "/System/Library/CoreServices/Menu Extras/User.menu"
done;

printf "%s\n" "System - Avoid creating .DS_Store files on network volumes."
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

printf "%s\n" "System - Expand save panel by default."
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

printf "%s\n" "System - Disable 'Are you sure you want to open this application?' dialog."
defaults write com.apple.LaunchServices LSQuarantine -bool false

printf "%s\n" "System - Disable window resume system-wide."
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false

# Set default screenshot location
printf "%s\n" "Screenshots - Set default location"
defaults write com.apple.screencapture location "$SCREENSHOT_LOCATION"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
printf "%s\n" "Screenshots - Change default type"
defaults write com.apple.screencapture type -string "png"

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

# Only use UTF-8 in Terminal.app
printf "%s\n" "Terminal - Only use UTF-8"
defaults write com.apple.terminal StringEncodings -array 4

# Don’t display the annoying prompt when quitting iTerm
printf "%s\n" "iTerm 2 - Don't Prompt on Quit"
defaults write com.googlecode.iterm2 PromptOnQuit -bool false
