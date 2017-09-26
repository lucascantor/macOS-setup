# load ssh keys from keychain into agent
ssh-add -A 2>/dev/null;

# GAM
alias gam="/Users/lucas/bin/gam/gam"

# open file in Sublime Text
# requires brew cask install sublime-text
# usage: slt filename
alias slt='open -a "Sublime Text"'

# ImageOptim
# requires brew cask install imageoptim
# usage: ImageOptim *.png
alias ImageOptim='/Applications/ImageOptim.app/Contents/MacOS/ImageOptim'

# Ale
# update, upgrade, and cleanup homebrew
alias ale='/usr/local/bin/brew update && /usr/local/bin/brew upgrade && /usr/local/bin/brew cleanup'

# Reset Launchpad
alias reset-launchpad='defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock'

# ffmpeg batch conversion of files in working directory
# requires brew install ffmpeg
# $1: original file format
# $2: output file format
# usage: batchconvert m4a mp3
function batchconvert() {
	for i in *."$1"; do ffmpeg -i "$i" "${i%.$1}.$2"; done
}

# createinstallmedia
# requires downloaded "Install macOS" app downloaded from Mac App Store and intallation media
# $1: path to "Install OS X" app downloaded from Mac App Store
# $2: path to installation media volume
# usage: createinstallmedia /Applications/Install\ OS\ X\ El\ Capitan.app /Volumes/Untitled/
function createinstallmedia() {
	sudo "$1"/Contents/Resources/createinstallmedia --volume "$2" --applicationpath "$1" --nointeraction
}

# Virtualenv Wrapper
export WORKON_HOME=$HOME/.virtualenvs
source $HOME/Library/Python/2.7/bin/virtualenvwrapper.sh
export PATH="$PATH:$HOME/Library/Python/2.7/bin"