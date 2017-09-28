#!/bin/bash

###############################################################################
# Confirm private keys in place to restore                                    #
###############################################################################

# Exit if gpg-keys directory is empty
if [ -f gpg-keys/REPLACE-ME-WITH-PRIVATE-GPG-KEYS ]
then
  echo "Error: please place private GPG key(s) in gpg-keys directory"
  exit 1
fi

# Exit if ssh-keys directory is empty
if [ -f ssh-keys/REPLACE-ME-WITH-PRIVATE-SSH-KEYS ]
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
# Saving and printing                                                         #
###############################################################################

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

###############################################################################
# Dock                                                                        #
###############################################################################

# Enable Dock auto-hidng
defaults write com.apple.dock autohide -bool true

# Disable Dock animation delays
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0

# Place Dock on right side of screen
defaults write com.apple.dock orientation right

# Remove icons from Dock
defaults write com.apple.dock persistent-apps -array

###############################################################################
# Security                                                                    #
###############################################################################

# Enable automatic Apple security updates
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool yes
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall -bool yes
sudo softwareupdate --schedule on
sudo softwareupdate --background-critical

# Require password immediately after sleep or screen saver begins
sudo defaults write com.apple.screensaver askForPassword -int 1
sudo defaults write com.apple.screensaver askForPasswordDelay -int 0

# Set login window text
sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "Lucas Cantor - 610.202.9708"

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
  ffmpeg \
  git \
  speedtest_cli \
  wget \
  youtube-dl \
  mas \
;

# Install software via Homebrew-Cask
brew cask install \
  1password \
  backblaze \
  gpgtools \
  google-chrome \
  google-backup-and-sync \
  imageoptim \
  keybase \
  transmit \
  spectacle \
  sublime-text \
  suspicious-package \
  virtualbox \
  vlc \
;

# Install software via mas
mas install \
  409907375 \
  1037126344 \
  1179623856 \
  557168941 \
  403504866 \
  407963104 \
  924726344 \
  1055273043 \
  937984704 \
  904280696 \
  1225570693 \
;

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

# Authorize public key
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCuZw8/bNgVcECchitUO1fNARNdCcfhPmL72CIVX46xjZH3zPJDWloZ45SxqN7ExktNETDaY35QHauAlZScSCrW7MwFouo4qrPTjpHzPcLj0Pz9FoTiFDqKujj8Lf7Bs+GLbSyJW34+/rUN8XAX7VVv+nutZqTIfrqLlfGk92hmz9B5+TVrOjPV+hdfVxkrmfkfANvfb9IjaIEaA9iOqFugEMEGzAU+lrmsEssSrA07qv7YKPNyab0DqMOJBIUI4TXe4B0xcBRAGr/zs6x9s4jd94+GjkEihqwZEjtSoFOXvaiQaRxu8O7Cjaq+sAfwNp/PLhm7rO65NTEMbuSrKVkABkBzltbleSgNR3bAU5XSix6/ckMasO2S1rvaiT6EWKKZFMWwLLutqcgqvaeKe9+8bdYaKCcrM+5qKyL1ULHAJKW6PyK5JeHHMzVeFvYbTcOX6j1AtnvGIVN7gwrWJMzhj+OLGFa70JW0TkHik0bO7t7OeJc3Vj4ZqZaQKHQQ6hOo6D5vO57NA+nqGautjFBI8dsAXo0khGzMoBlj2b8Ufn1saG6AlaB1RYLdMIr6a0daY9vfzsmH4dTBcwT7jY5boqvhZSeiOSM40vBIKOO0QRCPaVF6m9lcgKgWAxhnruSiifJTlVHCHMV/om5Un9oKdaV6zXBdXpLwtq7ZAATbwQ== lucascantor@gmail.com" >> ~/.ssh/authorized_keys

# Prohibit password auth
sudo sh -c "echo \"# sshd_config defaults - adopted from Mozilla guidelines\n# More info at https://wiki.mozilla.org/Security/Guidelines/OpenSSH\n\nAuthorizedKeysFile	.ssh/authorized_keys\n\n# Supported HostKey algorithms by order of preference.\nHostKey /etc/ssh/ssh_host_ed25519_key\nHostKey /etc/ssh/ssh_host_rsa_key\n\nKexAlgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256\n\nCiphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr\n\nMACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com\n\n# Password based logins are disabled - only public key based logins are allowed.\nAuthenticationMethods publickey\n\n# LogLevel VERBOSE logs user's key fingerprint on login. Needed to have a clear audit track of which key was using to log in.\nLogLevel VERBOSE\n\n# Log sftp level file access (read/write/etc.) that would not be easily logged otherwise.\nSubsystem	sftp	/usr/libexec/sftp-server -l INFO\n\n# Root login is not allowed for auditing reasons. This is because it's difficult to track which process belongs to which root user.\nPermitRootLogin No\n\n# Use kernel sandbox mechanisms where possible in unprivileged processes\nUsePrivilegeSeparation sandbox\" >> /etc/ssh/sshd_config" && sudo -k

###############################################################################
#                                                                             #
###############################################################################

exit 0
