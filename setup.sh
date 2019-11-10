#!/bin/bash

# Close System Preferences if open, to avoid conflicts
osascript -e 'tell application "System Preferences" to quit'

###############################################################################
# Confirm private keys in place to restore                                    #
###############################################################################

# Exit if private gpg keys are missing
gpgKeyCount=`grep -l "PGP PRIVATE KEY" gpg-keys/* | wc -l`
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
  npm \
  speedtest_cli \
  tree \
  wget \
  youtube-dl \
;

# Install software via Homebrew-Cask
brew cask install \
  1password \
  backblaze \
  firefox \
  gpg-suite \
  google-chrome \
  imageoptim \
  keybase \
  signal \
  spectacle \
  suspicious-package \
  transmit \
  visual-studio-code \
  vlc \
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
defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool TRUE
defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates -bool TRUE
defaults write /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall -bool TRUE
defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool TRUE
defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool TRUE
sudo softwareupdate --schedule on
sudo softwareupdate --background
sudo softwareupdate --background-critical


# Require password immediately after sleep or screen saver begins
sudo defaults write com.apple.screensaver askForPassword -int 1
sudo defaults write com.apple.screensaver askForPasswordDelay -int 0

# Set login window text
sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "lucas@cantor.cloud"

###############################################################################
# Dock                                                                        #
###############################################################################

# Enable Dock auto-hidng
sudo defaults write com.apple.dock autohide -bool true

# Minimize windows into their application’s icon
sudo defaults write com.apple.dock minimize-to-application -bool true

# Remove all default Dock icons
dockutil --remove all --no-restart

# Add Downloads folder to Dock
dockutil --add '~/Downloads' --view grid --display folder

###############################################################################
# Screenshots                                                                 #
###############################################################################

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
cp git-config/.gitconfig ~/

###############################################################################
# Zsh Profile                                                                 #
###############################################################################

# Restore and source zsh profile
cp zshrc/.zshrc ~/
source ~/.zshrc

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

# Restore and import SSH keys
mkdir -p ~/.ssh
cp ssh-keys/* ~/.ssh/
chmod 600 ~/.ssh/*
ssh-add -K ~/.ssh/*

# Restore ssh config
cp ssh-config/config ~/.ssh/config

# Restore sshd_config
sudo sh -c "echo \"# sshd_config defaults - adopted from Mozilla guidelines\n# More info at https://wiki.mozilla.org/Security/Guidelines/OpenSSH\n\nAuthorizedKeysFile	.ssh/authorized_keys\n\n# Supported HostKey algorithms by order of preference.\nHostKey /etc/ssh/ssh_host_ed25519_key\nHostKey /etc/ssh/ssh_host_rsa_key\n\nKexAlgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256\n\nCiphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr\n\nMACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com\n\n# Password based logins are disabled - only public key based logins are allowed.\nAuthenticationMethods publickey\n\n# LogLevel VERBOSE logs user's key fingerprint on login. Needed to have a clear audit track of which key was using to log in.\nLogLevel VERBOSE\n\n# Log sftp level file access (read/write/etc.) that would not be easily logged otherwise.\nSubsystem	sftp	/usr/libexec/sftp-server -l INFO\n\n# Root login is not allowed for auditing reasons. This is because it's difficult to track which process belongs to which root user.\nPermitRootLogin No\n\n# Use kernel sandbox mechanisms where possible in unprivileged processes\nUsePrivilegeSeparation sandbox\" > /etc/ssh/sshd_config" && sudo -k

###############################################################################
# Exit                                                                        #
###############################################################################

exit 0
