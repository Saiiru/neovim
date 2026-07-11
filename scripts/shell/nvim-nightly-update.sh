#!/usr/bin/env zsh

flavor=nvim-macos-x86_64

download_url="https://github.com/neovim/neovim/releases/download/nightly/${flavor}.tar.gz"
src=${HOME}/Downloads/${flavor}.tar.gz
dst=${HOME}/opt

[ -f $src ] &&  rm $src
curl -fsSL $download_url -o $src
if [ $? -ne 0 ]; then
  echo "Failed to download Neovim nightly! ($download_url)"
  exit 1
fi
[ -d $dst ] || mkdir -p $dst
[ -d $app ] && rm -rvf $app
xattr -c $src
tar xvzf $src -C $dst
rm -rvf $src

echo "Installed Neovim nightly!"




