# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if which systemd >/dev/null; then
	# java
	export PATH="/snap/intellij-idea-community/current/jbr/bin:$PATH"
	# kotlinc, kotlinc-js, kotlinc-jvm
	export PATH="/snap/intellij-idea-community/current/plugins/Kotlin/kotlinc/bin:$PATH"
	# intellij -- "idea.sh"
	export PATH="/snap/intellij-idea-community/current/bin:$PATH"
	
	# snap
	export PATH="/snap/bin:$PATH"
	export XDG_DATA_DIRS="/var/lib/snapd/desktop:$XDG_DATA_DIRS"
else ## Darwin
	
fi

# personal scripts
export PATH="$HOME/bin:$PATH"
