if command -v systemctl &>/dev/null; then
	echo "Linux configuration" >/dev/null
else
	echo "macOS configuration" >/dev/null
fi

# asdf
. "$HOME/.asdf/asdf.sh"
if [[ "$SHELL" = "/bin/bash" ]]; then
    . "$HOME/.asdf/completions/asdf.bash"
fi

# personal scripts
export PATH="$HOME/bin:$PATH"
