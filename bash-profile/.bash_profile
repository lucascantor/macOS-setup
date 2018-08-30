# ----------------------------------------------------------------------------------------------------------------------------
#
#  Lucas Cantor - bash profile
#
# -----------------------------------------------------
#
#  See current version:
#
#    https://github.com/lucascantor/macOS-setup/blob/master/bash-profile/.bash_profile
#
# ----------------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------
#  Environment configuration
# -----------------------------------------------------

# assume-role
source $(which assume-role)

function aws_account_info {
  [ "$AWS_ACCOUNT_NAME" ] && [ "$AWS_ACCOUNT_ROLE" ] && echo -n "aws:($AWS_ACCOUNT_NAME:$AWS_ACCOUNT_ROLE) "
}

PROMPT_COMMAND='aws_account_info'

# Node path
export NODE_PATH=/usr/local/lib/node_modules

# NVM
export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

# ----------------------------------------------------------------------------------
#  Aliases to command line tools
# -----------------------------------------------------

# ImageOptim
# optimize image file in imageoptim
# usage: ImageOptim *.png
alias ImageOptim='/Applications/ImageOptim.app/Contents/MacOS/ImageOptim'

# ----------------------------------------------------------------------------------
#  Task automation
# -----------------------------------------------------

# ale
# update, upgrade, and cleanup homebrew
# usage: ale
ale() {
	brew update
	brew upgrade
	brew cleanup
}

# -----------------------------------------------------

# mkzip
# create a ZIP archive of a directory
# usage: mkzip directory-name-here
mkzip() {
	zip -r "$1".zip "$1"
}

# -----------------------------------------------------

# extract
# extract most know archives with one command
# usage: extract archive-name-here.xxx
extract() {
	if [ -f $1 ] ; then
		case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

# -----------------------------------------------------

# cdfinder
# cd to frontmost window currently open in Finder
# usage: cdfinder
cdfinder() {
	currFolderPath=$( /usr/bin/osascript <<EOT
		tell application "Finder"
			try
		set currFolder to (folder of the front window as alias)
			on error
		set currFolder to (path to desktop folder as alias)
			end try
			POSIX path of currFolder
		end tell
EOT
	)
	echo "cd to \"$currFolderPath\""
	cd "$currFolderPath"
}

# -----------------------------------------------------

# mkcd
# make new directory and jump inside
# usage: mkcd directory-name-here
mkcd() { 
	mkdir -p "$1"
	cd "$1"
}

# -----------------------------------------------------

# trash
# move a file to the macOS trash
# usage: trash file-name-here
trash() {
	mv "$@" ~/.Trash
}

# -----------------------------------------------------

# quicklook
# view file using macOS Quicklook preview
# usage: quicklook file-name-here
quicklook() {
	qlmanage -p "$*" >& /dev/null
}

# -----------------------------------------------------

# spotlight
# search for a file using macOS Spotlight metadata
# usage: spotlight file-name-here
spotlight() {
	mdfind "kMDItemDisplayName == '$@'wc"
}

# -----------------------------------------------------

# reset-launchpad
# order apps alphabetically in Launchpad
# usage: reset-launchpad
reset-launchpad() {
	defaults write com.apple.dock ResetLaunchPad -bool true
	killall Dock
}

# -----------------------------------------------------

# clean-ds
# recursively delete .DS_Store files
# usage: clean-ds
clean-ds() {
	find . -type f -name '*.DS_Store' -ls -delete
}

# -----------------------------------------------------

# batch-convert
# batch conversion of files in working directory
# $1: original file format extension (e.g., xxx)
# $2: output file format extension (e.g., yyy)
# usage: batch-convert xxx yyy
batch-convert() {
	for i in *."$1"; do
		ffmpeg -i "$i" "${i%.$1}.$2"
	done
}

# -----------------------------------------------------

# create-install-media
# $1: path to "Install macOS" app downloaded from Mac App Store
# $2: path to installation media volume
# usage: create-install-media /Applications/Install\ macOS\ High\ Sierra.app /Volumes/Untitled/
create-install-media() {
	sudo "$1"/Contents/Resources/createinstallmedia --volume "$2" --applicationpath "$1" --nointeraction
}

# -----------------------------------------------------

# ip
# show public and private IP addresses
# usage: ip
ip() {
	echo -en "\nPublic:\n• WAN: "
	dig +short myip.opendns.com @resolver1.opendns.com
	echo -en "Private:"
	for interface in $(networksetup -listnetworkserviceorder | grep -E 'en[0-99]' | awk '/en[0-99]/ { print $NF }' | awk -F ")" '{ print $1 }'); do
		ip=$(ipconfig getifaddr "$interface")
		if [[ -n "$ip" ]]; then
			echo -en "\n• $interface: $ip"
		fi
	done
	printf "\n\n"
}

# -----------------------------------------------------

# emails
# filter unique email addresses out of a text file
# usage: emails filename.txt
emails() {
	grep -o '[[:alnum:]+\.\_\-]*@[[:alnum:]+\.\_\-]*' "$1" | sort | uniq -i
}

# -----------------------------------------------------

# plcat
# read the standard XML version of a plist (whether it’s in binary format or already in XML)
# $1: path to the plist file to read
# usage: plcat /path/to/foo.plist
plcat() {
	plutil -convert xml1 -o - "$1"
}

# -----------------------------------------------------

# ssh-proxy
# open a SOCKS tunnel on the specified port over SSH to the specified server
# $1: port to use
# $2: server to use
# usage: ssh-proxy 1234 1.2.3.4
ssh-proxy() {
	ssh -D "$1" -f -C -q -N "$2"
	local proxyPID=$(pgrep -n ssh)
	networksetup -setsocksfirewallproxy "Wi-Fi" localhost "$1"

	echo "Proxy now open on port $1 to $2"
	echo "Process ID: $proxyPID"
	read -p "Press return to close the connection..."

	networksetup -setsocksfirewallproxystate "Wi-Fi" off
	kill "$proxyPID"

	echo "Connection closed"
}

# ----------------------------------------------------------------------------------
#  Customize usage for common tools
# -----------------------------------------------------

alias cp='cp -iv'                          				# cp:           Preferred 'cp' implementation
alias mv='mv -iv'                          				# mv:           Preferred 'mv' implementation
alias mkdir='mkdir -pv'                    				# mkdir:        Preferred 'mkdir' implementation
alias ls='ls -FGlAhp'                       			# ls:           Preferred 'ls' implementation
alias less='less -FSRXc'                    			# less:         Preferred 'less' implementation
alias finder='open -a Finder ./'            			# finder:       Opens present working directory in Finder
alias slt='open -a "Sublime Text"'          			# slt:          Opens any file in Sublime Text
cd() { builtin cd "$@"; git pull 2>/dev/null; ls; }		# cd:           Perform git pull and ls upon 'cd'
