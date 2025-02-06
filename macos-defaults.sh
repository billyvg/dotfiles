# Sets reasonable macOS defaults.
#
# Or, in other words, set shit how I like in macOS.
#
# The original idea (and a couple settings) were grabbed from:
#   https://github.com/mathiasbynens/dotfiles/blob/master/.macos
#
# Run ./set-defaults.sh and you'll be good to go.

# Disable press-and-hold for keys in favor of key repeat.
defaults write -g ApplePressAndHoldEnabled -bool false

# Use AirDrop over every interface. srsly this should be a default.
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1
# Always open everything in Finder's list view. This is important.
defaults write com.apple.Finder FXPreferredViewStyle Nlsv

# Show the ~/Library folder.
chflags nohidden ~/Library

# Set a really fast key repeat.
defaults write NSGlobalDomain KeyRepeat -int 1

# Set the Finder prefs for showing a few different volumes on the Desktop.
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Run the screensaver if we're in the top-left hot corner.
defaults write com.apple.dock wvous-tl-corner -int 5
defaults write com.apple.dock wvous-tl-modifier -int 0

# Hide Safari's bookmark bar.
defaults write com.apple.Safari ShowFavoritesBar -bool false

# Set up Safari for development.
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Set dock to left and autohide
defaults write com.apple.dock "orientation" -string "left"
defaults write com.apple.dock "tilesize" -int "36"
defaults write com.apple.dock "autohide" -bool "true"
killall Dock


# Key mapping via https://gist.github.com/benjifs/054e00deee252b5bb1b88e7afe590794
# Map Caps Lock key to Escape key
# https://developer.apple.com/library/content/technotes/tn2450/_index.html
# This doesnt work. Reverts on restart
# hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x7000000E0}]}'
# References:
# https://github.com/mathiasbynens/dotfiles/issues/310
# https://gist.github.com/scottstanfield/0f8ce63271bebfb5cf2bb91e72c71f91
# The last link didnt work for me on Sierra or High Sierra. I could not find IOHIDKeyboard but
# IOHIDInterface had the values I was looking for

# VENDOR_ID=$(ioreg -n IOHIDInterface -r | awk '$2 == "\"VendorID\"" { print $4 }')
# PRODUCT_ID=$(ioreg -n IOHIDInterface -r | awk '$2 == "\"ProductID\"" { print $4 }')
#
# n1=$(echo -n "$VENDOR_ID" | grep -c "^")
# n2=$(echo -n "$PRODUCT_ID" | grep -c "^")
#
# if [ $n1 -eq $n2 ]; then
# 	KBS=""
# 	# Handling multiple VendorID and ProductID combos
# 	while read -r VID && read -r PID <&3; do
# 		if [ -n "$KBS" ]; then
# 			KBS+=" "
# 		fi
# 		KBS+="$VID-$PID-0"
# 		done <<< "$VENDOR_ID" 3<<< "$PRODUCT_ID"
#
# 		KBS=$(echo $KBS | xargs -n1 | sort -u)
# 		while read -r KB; do
# 			defaults -currentHost write -g com.apple.keyboard.modifiermapping.$KB -array \
# '<dict>
# <key>HIDKeyboardModifierMappingDst</key>
# <integer>30064771113</integer>
# <key>HIDKeyboardModifierMappingSrc</key>
# <integer>30064771129</integer>
# </dict>
# <dict>
# <key>HIDKeyboardModifierMappingDst</key>
# <integer>30064771125</integer>
# <key>HIDKeyboardModifierMappingSrc</key>
# <integer>30064771113</integer>
# </dict>'
# 		done <<< "$KBS"
# fi
