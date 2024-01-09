#!/bin/bash

set -e
RBENV_OR_DEV_PATH="$1"
VIM_VERSION="$2"

if [ -z "$RBENV_OR_DEV_PATH" ]; then
	echo "RBENV_OR_DEV_PATH not specified. Please provide one as the first parameter." >&2
	echo -e "\t(e.g. \$HOME/.local/share/rbenv/versions/2.5.9)" >&2
	exit 1
fi

if [ -z "$VIM_VERSION" ]; then
  VIM_VERSION="$(cd git/vim/vim; git tag | tail -1)"
fi

echo $VIM_VERSION

sudo dpkg -P vim vim-runtime vim-common vim-tiny

sudo apt install libncurses5-dev libperl-dev python3-dev mercurial checkinstall lua5.4 liblua5.4-dev
sudo update-alternatives --set lua-interpreter /usr/bin/lua5.4
sudo update-alternatives --set lua-compiler /usr/bin/luac5.4
sudo ln -s --no-target-directory -f /usr/include/lua5.4 /usr/include/lua

export CPPFLAGS="-I$RBENV_OR_DEV_PATH/include"
export LDFLAGS="-L$RBENV_OR_DEV_PATH/lib"
export PKG_CONFIG_PATH="$RBENV_OR_DEV_PATH/lib/pkgconfig"

pushd $HOME/git/vim/vim
	make distclean
	git fetch origin
	git checkout "$VIM_VERSION"
	VER=`git describe --exact-match --tags $(git log -n1 --pretty='%h')`
	make distclean
	./configure \
		--enable-gui=no \
		--with-features=huge \
                --enable-cscope \
		--enable-luainterp \
		--enable-perlinterp \
		--enable-pythoninterp \
		--enable-rubyinterp
	make
	sudo checkinstall -y --pkgversion "$(cat $VER | sed 's/^v//')"
popd

echo "vim hold" | sudo dpkg --set-selections

pushd $HOME/.vim/bundle/command-t/ruby/command-t/ext/command-t/
	ruby extconf.rb
	make
popd

gem install solargraph
vim '+PluginInstall' '+CocInstall coc-json coc-tsserver coc-solargraph'
