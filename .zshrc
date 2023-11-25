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

precmd () {
	local SUCCESS=$?
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

export NVM_DIR=~/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# pnpm
export PNPM_HOME="/home/sam/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end