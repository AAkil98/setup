#!/usr/bin/env bash
# Step 7 — sensible macOS system preferences (all reversible).
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

log "Step 7: macOS system preferences"

# Keyboard — fast key repeat is great for coding.
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Finder — show extensions, path/status bars, the Library folder.
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
chflags nohidden "$HOME/Library" 2>/dev/null || true

# Screenshots — PNG files saved to ~/Screenshots.
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location "$HOME/Screenshots"
defaults write com.apple.screencapture type -string "png"

# Dock — auto-hide, modest icon size, don't reshuffle spaces.
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 48
defaults write com.apple.dock mru-spaces -bool false

# Expand Save/Print dialogs by default.
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

ok "Preferences written — restarting Finder, Dock, SystemUIServer..."
killall Finder Dock SystemUIServer 2>/dev/null || true
warn "A few changes only take full effect after a logout/restart."
