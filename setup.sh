#!/bin/bash

# Close System Preferences if open, to avoid conflicts
osascript -e 'tell application "System Preferences" to quit'

###############################################################################
# Confirm private keys in place to restore                                    #
###############################################################################

# Exit if private gpg keys are missing
gpgKeyCount=`grep -l "RSA PRIVATE KEY" gpg-keys/* | wc -l`
if [ $gpgKeyCount == 0 ]
then
  echo "Error: please place private GPG key(s) in gpg-keys directory"
  exit 1
fi

# Exit if private ssh keys are missing
sshKeyCount=`grep -l "RSA PRIVATE KEY" ssh-keys/* | wc -l`
if [ $sshKeyCount == 0 ]
then
  echo "Error: please place private SSH key(s) in ssh-keys directory"
  exit 1
fi

###############################################################################
# Firmware                                                                    #
###############################################################################

# Clear NVRAM
sudo /usr/sbin/nvram -c

###############################################################################
# Software Installations                                                      #
###############################################################################

# Install and update Homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
brew upgrade
brew cleanup

# Install software via Homebrew
brew install \
  dockutil \
  ffmpeg \
  git \
  mas \
  speedtest_cli \
  tree \
  wget \
  youtube-dl \
;

# Install software via Homebrew-Cask
brew cask install \
  1password \
  backblaze \
  blockblock \
  flow \
  gpgtools \
  google-chrome \
  google-drive-file-stream \
  imageoptim \
  keybase \
  oversight \
  spectacle \
  sublime-text \
  suspicious-package \
  transmit \
  virtualbox \
  vlc \
;

# Install software via mas
mas install \
  409907375 `#apple remote desktop` \
  1037126344 `#apple configurator 2` \
  1179623856 `#pastebot` \
  557168941 `#tweetbot` \
  403504866 `#pcalc` \
  407963104 `#pixelmator` \
  924726344 `#deliveries` \
  1055273043 `#pdf expert` \
  937984704 `#amphetamine` \
  904280696 `#things 3` \
  1091189122 `#bear` \
;

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Expand save panel by default
sudo defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
sudo defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
sudo defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
sudo defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
sudo defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Automatically quit printer app once the print jobs complete
sudo defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Restart automatically if the computer freezes
sudo systemsetup -setrestartfreeze on

# Disable automatic capitalization as it’s annoying when typing code
sudo defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
sudo defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it’s annoying when typing code
sudo defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they’re annoying when typing code
sudo defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Enable full keyboard access for all controls
sudo defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Use scroll gesture with the Ctrl (^) modifier key to zoom
sudo defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
sudo defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
# Follow the keyboard focus while zoomed in
sudo defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
sudo defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Show all filename extensions in Finder
sudo defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show status bar in Finder
sudo defaults write com.apple.finder ShowStatusBar -bool true

# Show path bar in Finder
sudo defaults write com.apple.finder ShowPathbar -bool true

###############################################################################
# Security                                                                    #
###############################################################################

# Enable all automatic Apple software updates
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall -bool true
sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool true
sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdateRestartRequired -bool true
sudo softwareupdate --schedule on
sudo softwareupdate --background
sudo softwareupdate --background-critical


# Require password immediately after sleep or screen saver begins
sudo defaults write com.apple.screensaver askForPassword -int 1
sudo defaults write com.apple.screensaver askForPasswordDelay -int 0

# Set login window text
sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "Lucas Cantor - 610.202.9708"

###############################################################################
# Dock                                                                        #
###############################################################################

# Enable Dock auto-hidng
sudo defaults write com.apple.dock autohide -bool true

# Disable Dock animation delays
sudo defaults write com.apple.dock autohide-delay -float 0
sudo defaults write com.apple.dock autohide-time-modifier -float 0

# Minimize windows into their application’s icon
sudo defaults write com.apple.dock minimize-to-application -bool true

# Place Dock on right side of screen
sudo defaults write com.apple.dock orientation right

# Remove icons from Dock
dockutil --remove all --no-restart

# Add icons to Dock
dockutil --add /Applications/Google\ Chrome.app --no-restart
dockutil --add /Applications/Tweetbot.app --no-restart
dockutil --add /Applications/Messages.app --no-restart
dockutil --add /Applications/Things3.app --no-restart
dockutil --add /Applications/Bear.app --no-restart
dockutil --add /Applications/Utilities/Terminal.app --no-restart
dockutil --add /Applications/Sublime\ Text.app

###############################################################################
# Screenshots                                                                 #
###############################################################################

# Save screenshots to ~/Documents/Screenshots which is synced by iCloud Drive
sudo defaults write com.apple.screencapture location ~/Documents/Screenshots/

# Disable capturing window shadows in screenshots
sudo defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Safari                                                                      #
###############################################################################

# Show the full URL in the Safari address bar
sudo defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Prevent Safari from opening ‘safe’ files automatically after downloading
sudo defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Hide Safari’s bookmarks bar by default
sudo defaults write com.apple.Safari ShowFavoritesBar -bool false

# Enable Safari’s debug menu
sudo defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Enable Safari's Develop menu and the Web Inspector
sudo defaults write com.apple.Safari IncludeDevelopMenu -bool true
sudo defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
sudo defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Disable AutoFill
sudo defaults write com.apple.Safari AutoFillFromAddressBook -bool false
sudo defaults write com.apple.Safari AutoFillPasswords -bool false
sudo defaults write com.apple.Safari AutoFillCreditCardData -bool false
sudo defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

# Warn about fraudulent websites
sudo defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

# Disable plug-ins
sudo defaults write com.apple.Safari WebKitPluginsEnabled -bool false
sudo defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled -bool false

# Disable Java
sudo defaults write com.apple.Safari WebKitJavaEnabled -bool false
sudo defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false

# Block pop-up windows
sudo defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
sudo defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

# Enable “Do Not Track”
sudo defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

# Update extensions automatically
sudo defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

###############################################################################
# TextEdit                                                                    #
###############################################################################

# Use plain text mode for new TextEdit documents
sudo defaults write com.apple.TextEdit RichText -int 0
# Open and save files as UTF-8 in TextEdit
sudo defaults write com.apple.TextEdit PlainTextEncoding -int 4
sudo defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

###############################################################################
# Git                                                                         #
###############################################################################

# Restore all git defaults
cp git-config/.gitconfig* ~/

# Restore setgit and make executable in path
cp set-git/setgit /usr/local/bin/setgit
chmod +x /usr/local/bin/setgit

###############################################################################
# Bash Profile                                                                #
###############################################################################

# Restore and source bash profile
cp bash-profile/.bash_profile ~/
source ~/.bash_profile

###############################################################################
# GPG                                                                         #
###############################################################################

# Import GPG keys
for key in gpg-keys/*
do
  gpg --import $key
done

###############################################################################
# SSH                                                                         #
###############################################################################

# Enable SSH
sudo systemsetup -setremotelogin on

# Restore and import SSH keys
mkdir -p ~/.ssh
cp ssh-keys/* ~/.ssh/
chmod 600 ~/.ssh/*
ssh-add -K ~/.ssh/*

# Restore ssh config
cp ssh-config/config ~/.ssh/config

# Restore sshd_config
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCuZw8/bNgVcECchitUO1fNARNdCcfhPmL72CIVX46xjZH3zPJDWloZ45SxqN7ExktNETDaY35QHauAlZScSCrW7MwFouo4qrPTjpHzPcLj0Pz9FoTiFDqKujj8Lf7Bs+GLbSyJW34+/rUN8XAX7VVv+nutZqTIfrqLlfGk92hmz9B5+TVrOjPV+hdfVxkrmfkfANvfb9IjaIEaA9iOqFugEMEGzAU+lrmsEssSrA07qv7YKPNyab0DqMOJBIUI4TXe4B0xcBRAGr/zs6x9s4jd94+GjkEihqwZEjtSoFOXvaiQaRxu8O7Cjaq+sAfwNp/PLhm7rO65NTEMbuSrKVkABkBzltbleSgNR3bAU5XSix6/ckMasO2S1rvaiT6EWKKZFMWwLLutqcgqvaeKe9+8bdYaKCcrM+5qKyL1ULHAJKW6PyK5JeHHMzVeFvYbTcOX6j1AtnvGIVN7gwrWJMzhj+OLGFa70JW0TkHik0bO7t7OeJc3Vj4ZqZaQKHQQ6hOo6D5vO57NA+nqGautjFBI8dsAXo0khGzMoBlj2b8Ufn1saG6AlaB1RYLdMIr6a0daY9vfzsmH4dTBcwT7jY5boqvhZSeiOSM40vBIKOO0QRCPaVF6m9lcgKgWAxhnruSiifJTlVHCHMV/om5Un9oKdaV6zXBdXpLwtq7ZAATbwQ== lucascantor@gmail.com" >> ~/.ssh/authorized_keys

# Prohibit password auth
sudo sh -c "echo \"# sshd_config defaults - adopted from Mozilla guidelines\n# More info at https://wiki.mozilla.org/Security/Guidelines/OpenSSH\n\nAuthorizedKeysFile	.ssh/authorized_keys\n\n# Supported HostKey algorithms by order of preference.\nHostKey /etc/ssh/ssh_host_ed25519_key\nHostKey /etc/ssh/ssh_host_rsa_key\n\nKexAlgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256\n\nCiphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr\n\nMACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com\n\n# Password based logins are disabled - only public key based logins are allowed.\nAuthenticationMethods publickey\n\n# LogLevel VERBOSE logs user's key fingerprint on login. Needed to have a clear audit track of which key was using to log in.\nLogLevel VERBOSE\n\n# Log sftp level file access (read/write/etc.) that would not be easily logged otherwise.\nSubsystem	sftp	/usr/libexec/sftp-server -l INFO\n\n# Root login is not allowed for auditing reasons. This is because it's difficult to track which process belongs to which root user.\nPermitRootLogin No\n\n# Use kernel sandbox mechanisms where possible in unprivileged processes\nUsePrivilegeSeparation sandbox\" >> /etc/ssh/sshd_config" && sudo -k

###############################################################################
#                                                                             #
###############################################################################

exit 0
