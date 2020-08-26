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
else ## BSD
	echo "Darwin not yet implemented."
fi

# if node still not in PATH, then assume system is using nvm
if ! command -v node &>/dev/null; then
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# kotlin-language-server
# TODO: move/add as submodule
export PATH="$PATH:/home/sam/Development/sammoore/kotlin-language-server/server/build/install/server/bin"

# personal scripts
export PATH="$HOME/bin:$PATH"
