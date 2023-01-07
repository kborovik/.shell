#!/usr/bin/env bash

set -e

dirs=(
  ~/bin
  ~/.gnupg
  ~/.local/bin
  ~/tmp
)
mkdir -p "${dirs[@]}"

arch=""
case $(uname -m) in
  x86_64) arch="amd64" ;;
  arm64) arch="arm64" ;;
esac

cosign_binary="cosign-$(uname)-$arch"
posh_binary="posh-$(uname)-$arch"

echo "==> Download cosign"
wget -q "https://github.com/sigstore/cosign/releases/latest/download/$cosign_binary.sig" -O "$HOME/bin/$cosign_binary.sig" || exit 1
wget -q "https://github.com/sigstore/cosign/releases/latest/download/$cosign_binary" -O "$HOME/bin/cosign" && chmod +x "$HOME/bin/cosign" || exit 1

echo "==> Verify cosign signature"
~/bin/cosign verify-blob --key "$HOME/.shell/cosign/cosign.pub" --signature "$HOME/bin/$cosign_binary.sig" "$HOME/bin/cosign" && rm "$HOME/bin/$cosign_binary.sig" || exit 1

echo "==> Download oh-my-posh"
wget -q "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/$posh_binary.sig" -O "$HOME/bin/$posh_binary.sig" || exit 1
wget -q "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/$posh_binary" -O "$HOME/bin/$posh_binary" && chmod +x "$HOME/bin/$posh_binary" || exit 1

echo "==> Verify oh-my-posh signature"
if ~/bin/cosign verify-blob --key "$HOME/.shell/cosign/oh-my-posh.pub" --signature "$HOME/bin/$posh_binary.sig" "$HOME/bin/$posh_binary"; then
  mv "$HOME/bin/$posh_binary" "$HOME/bin/oh-my-posh"
  rm "$HOME/bin/$posh_binary.sig"
else
  exit 1
fi

echo "==> Link config files"
files=(
  .bashrc
  .digrc
  .gnupg/gpg-agent.conf
  .gnupg/gpg.conf
  .gnupg/scdaemon.conf
  .profile
  .vimrc
)
for file in "${files[@]}"; do
  ln -s -r -f "$HOME/.shell/$file" "$HOME/$file"
done

ln -s -r -f "$HOME/.shell/.vim" "$HOME"
