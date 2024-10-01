# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/sam/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

chpwd () {
	# check for nvmrc
	if [ -f .nvmrc ] && which asdf >/dev/null; then
		echo "Found .nvmrc with ""$(cat .nvmrc)"", attempting to change..."
		local VERSION="$(cat .nvmrc)"

		# convert nvmrc syntax to asdf
		if [[ $VERSION =~ .x$ ]]; then
			VERSION="$(printf $VERSION | sed 's/[.]x//')"
		elif [[ $VERSION =~ ^v ]]; then
			VERSION="$(printf $VERSION | sed 's/^v//')"
		fi

		# does nothing to exact matches, resolves latest for nvmrc syntax conversation
		VERSION="$(asdf latest nodejs $VERSION)"

		if ! asdf shell nodejs $VERSION; then
			echo "\ttry: printf \"install"'\\n'"shell\" | xargs -I {} asdf {} nodejs $VERSION"
		else
			echo "now using nodejs $VERSION"
		fi
	fi
}

INIT="0"

precmd () {
	local SUCCESS=$?

	if [ $INIT -lt 1 ]; then
		INIT=1
		chpwd
	fi

	# generate prompt
	local PROMPT_COLOR="green"

	if [ "$SUCCESS" -gt 0 ]; then
		PROMPT_COLOR="red"
	fi

	local BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

	if [ ! -z "$BRANCH" ]; then
		BRANCH="($BRANCH)"
	fi

	# use a colored CLI prompt for readability
	export PROMPT='%F{blue}%m%f %F{cyan}%1~%f %F{magenta}'"$BRANCH"'%f'$'\n''%F{'"$PROMPT_COLOR"'}%#%f '
}

. $HOME/.bash_profile

# nvm
export NVM_DIR=~/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# bun completions
[ -s "/home/sam/.bun/_bun" ] && source "/home/sam/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="/home/sam/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
