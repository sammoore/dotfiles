if command -v systemctl &>/dev/null; then
        echo "Welcome to $(uname)!"
else
	## Darwin (macOS)
	if command -v launchctl &>/dev/null; then
		echo "Welcome to Darwin!"

		if command -v /opt/local/bin/port &>/dev/null; then
			export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
		fi

		if [ -d /opt/homebrew/opt/python@3.11 ]; then
			export PATH="/opt/homebrew/opt/python@3.11/libexec/bin:$PATH"
			export PATH="$HOME/Library/Python/3.11/bin:$PATH"
		fi
	else
		echo "Welcome to BSD (not implemented)."
	fi
fi

# check for asdf and use it if installed
if [ -d $HOME/.asdf ]; then
	. "$HOME/.asdf/asdf.sh"
fi

# if node still not in PATH, then assume system is using nvm
# this can be run multiple times
if ! command -v node &>/dev/null; then
	export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
fi

# attempt to install rbenv if not already defined
if ! command -v rbenv &>/dev/null; then
	export PATH="$HOME/.rbenv/bin:$PATH"
	hash -r

	if command -v rbenv &>/dev/null; then
		export RBENV_ROOT="$HOME/.local/share/rbenv"
		eval "$(rbenv init -)"
	fi
fi

# yarn nonsense
export PATH="/home/sam/.yarn/bin:$PATH"

# personal scripts
export PATH="$HOME/bin:$PATH"

# python user packages
export PATH="$HOME/.local/bin:$PATH"

export EDITOR="$(which vim)"
