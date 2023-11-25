
if command -v systemctl &>/dev/null; then
	## java
	#export PATH="/snap/intellij-idea-community/current/jbr/bin:$PATH"
	## kotlinc, kotlinc-js, kotlinc-jvm
	#export PATH="/snap/intellij-idea-community/current/plugins/Kotlin/kotlinc/bin:$PATH"
	## intellij -- "idea.sh"
	#export PATH="/snap/intellij-idea-community/current/bin:$PATH"
	#
	## snap
	#export PATH="/snap/bin:$PATH"
	#export XDG_DATA_DIRS="/var/lib/snapd/desktop:$XDG_DATA_DIRS"

        echo "Nothing to do." >/dev/null
else
	## BSD or Darwin
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
		echo "BSD not implemented."
	fi
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
