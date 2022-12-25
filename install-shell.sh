#!/usr/bin/env bash

set -e

dirs=(
  ~/.gnupg
  ~/.local/bin
  ~/tmp
)
mkdir -p "${dirs[@]}"

case $(uname) in
Linux)
  cosign_binary="cosign-linux-amd64"
  posh_binary="posh-linux-amd64"
  ;;
Darwin)
  cosign_binary="cosign-darwin-$(uname -m)"
  posh_binary="posh-darwin-$(uname -m)"
  ;;
esac

echo "==> Download cosign"
wget -q "https://github.com/sigstore/cosign/releases/latest/download/$cosign_binary.sig" -O "$HOME/bin/$cosign_binary.sig" || exit 1
wget -q "https://github.com/sigstore/cosign/releases/latest/download/$cosign_binary" -O "$HOME/bin/cosign" && chmod +x "$HOME/bin/cosign" || exit 1

echo "==> Verify cosign signature"
cosign verify-blob --key "$HOME/.shell/cosign/cosign.pub" --signature "$HOME/bin/$cosign_binary.sig" "$HOME/bin/cosign" && rm "$HOME/bin/$cosign_binary.sig" || exit 1

echo "==> Download oh-my-posh"
wget -q "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/$posh_binary.sig" -O "$HOME/bin/$posh_binary.sig" || exit 1
wget -q "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/$posh_binary" -O "$HOME/bin/$posh_binary" && chmod +x "$HOME/bin/$posh_binary" || exit 1

echo "==> Verify oh-my-posh signature"
if cosign verify-blob --key "$HOME/.shell/cosign/oh-my-posh.pub" --signature "$HOME/bin/$posh_binary.sig" "$HOME/bin/$posh_binary"; then
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
