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
