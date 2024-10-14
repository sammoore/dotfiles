# This .bash_profile is meant to be executed by the login shell, including zsh.
#
# 1. .zshrc should source this file
# 2. any POSIX-compatiable environment setup (bash or zsh) should happen here
# 3. this file will get executed by bash 3.2 on older Mac OS versions
#
# Per the above, this file should be relatively portable shell.


# Use sparingly / avoid shell-specific code. Acceptable for:
#
# 1. conditionally loading shell completions
# 2. not executing vendor initialization scripts (e.g. asdf) to avoid an error
# 2. outputting information about the shell
shell()
{
	local value="$0"

	# bash (possibly 3.2 / macos-bundled version) workaround
	if [ bash != "$value" ]; then
		value="$SHELL"
	fi

	printf $value
}


# Debug messaging & conditional environment setup based on OS.
if command -v systemctl &>/dev/null; then
        echo "Welcome to $(uname)!"
else
	## Darwin (macOS)
	if command -v launchctl &>/dev/null; then
		echo "Welcome to Darwin!"
		echo "Using $($(shell) --version | head -1)"
		echo ""
		echo "Populating SDKs from homebrew & macports..."

		if [ -d /opt/homebrew/opt/python@3.11 ]; then
			export PATH="/opt/homebrew/opt/python@3.11/libexec/bin:$PATH"
			export PATH="$HOME/Library/Python/3.11/bin:$PATH"
		fi

		if [ -d /usr/local/opt/openjdk@11 ]; then
			export PATH="/usr/local/opt/openjdk@11/bin:$PATH"
			export JAVA_HOME="$(/usr/libexec/java_home -v 11)"
		fi

		if [ -d /usr/local/opt/openjdk@17 ]; then
			export PATH="/usr/local/opt/openjdk@17/bin:$PATH"
			export JAVA_HOME="$(/usr/libexec/java_home -v 17)"
		fi

		# macports; if present it should supercede the prior homebrew setup
		if command -v /opt/local/bin/port &>/dev/null; then
			export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

			if [ -d /Library/Java/JavaVirtualMachines/openjdk17-temurin/Contents/Home ]; then
				export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk17-temurin/Contents/Home"
			fi
		fi
	else
		echo "Welcome to BSD (not implemented)."
	fi
fi

# check for asdf and use it if installed
if [ -d $HOME/.asdf ]; then
	echo "Loading asdf..."
	. "$HOME/.asdf/asdf.sh"
	
	if [ bash = "$(shell)" ]; then
		echo "Loading asdf bash completions..."
		. "$HOME/.asdf/completions/asdf.bash"
	fi
fi

# if node still not in PATH, then assume system is using nvm
# this can be run multiple times
if ! command -v node &>/dev/null; then
	echo "Loading nvm..."
	export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
	command -v node &>/dev/null \
		|| echo "warning: node not found; is nvm installed?"
fi

# attempt to install rbenv if not already defined
if ! command -v rbenv &>/dev/null; then
	echo "Loading rbenv..."
	export PATH="$HOME/.rbenv/bin:$PATH"
	hash -r

	if command -v rbenv &>/dev/null; then
		export RBENV_ROOT="$HOME/.local/share/rbenv"
		eval "$(rbenv init -)"
	else
		echo "warning: rbenv not found, did you install it?"
	fi
fi

echo "Updating environment..."

alias la="ls -la --color=auto"
alias lap="ls -lap --color=auto"
alias lp="ls -lp --color=auto"

# yarn nonsense
export PATH="/home/sam/.yarn/bin:$PATH"

# kotlin-language-server
export PATH="$PATH:$HOME/git/fwcd/kotlin-language-server/server/build/install/server/bin"
if ! command -v kotlin-language-server &>/dev/null; then
	echo "warning: kotlin-language-server not found; did you build it?"
fi

# personal scripts
export PATH="$HOME/bin:$PATH"

# python user packages
export PATH="$HOME/.local/bin:$PATH"

## rust/cargo packages
source "$HOME/.cargo/env"

export EDITOR="$(which vim)"
