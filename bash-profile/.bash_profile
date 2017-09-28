# --------------------------------------------------------------------------------------------------------
#
# Lucas Cantor - bash configuration
#
# See current version at https://github.com/lucascantor/macOS-setup/blob/master/bash-profile/.bash_profile
#
# --------------------------------------------------------------------------------------------------------

# SSH keys
# load ssh keys from keychain into agent
ssh-add -A 2>/dev/null;

# Virtualenv Wrapper
export WORKON_HOME=$HOME/.virtualenvs
source $HOME/Library/Python/2.7/bin/virtualenvwrapper.sh
export PATH="$PATH:$HOME/Library/Python/2.7/bin"

# GAM
# command line G Suite admin tool
# usage: https://github.com/jay0lee/GAM/wiki
alias gam="~/bin/gam/gam"

# Sublime Text
# open any file in Sublime Text
# usage: slt filename
alias slt='open -a "Sublime Text"'

# ImageOptim
# optimize image file in imageoptim
# usage: ImageOptim *.png
alias ImageOptim='/Applications/ImageOptim.app/Contents/MacOS/ImageOptim'

# Ale
# update, upgrade, and cleanup homebrew
alias ale='/usr/local/bin/brew update && /usr/local/bin/brew upgrade && /usr/local/bin/brew cleanup'

# Reset Launchpad
# order apps alphabetically in Launchpad
alias reset-launchpad='defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock'

# ffmpeg batch conversion of files in working directory
# $1: original file format
# $2: output file format
# usage: batchconvert m4a mp3
function batchconvert() {
	for i in *."$1"; do ffmpeg -i "$i" "${i%.$1}.$2"; done
}

# createinstallmedia
# $1: path to "Install macOS" app downloaded from Mac App Store
# $2: path to installation media volume
# usage: createinstallmedia /Applications/Install\ macOS\ High\ Sierra.app /Volumes/Untitled/
function createinstallmedia() {
	sudo "$1"/Contents/Resources/createinstallmedia --volume "$2" --applicationpath "$1" --nointeraction
}