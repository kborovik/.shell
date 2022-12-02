#!/usr/bin/env bash

set -e

dirs=(
  ~/.local/bin/
  ~/.gnupg/
  ~/.vim/colors/
  ~/.vim/swaps/
  ~/.config/helix/
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
wget -q "https://github.com/sigstore/cosign/releases/latest/download/$cosign_binary.sig" -O "$HOME/.local/bin/$cosign_binary.sig" || exit 1
wget -q "https://github.com/sigstore/cosign/releases/latest/download/$cosign_binary" -O "$HOME/.local/bin/cosign" && chmod +x "$HOME/.local/bin/cosign" || exit 1

echo "==> Verify cosign signature"
cosign verify-blob --key "$HOME/.shell/cosign/cosign.pub" --signature "$HOME/.local/bin/$cosign_binary.sig" "$HOME/.local/bin/cosign" && rm "$HOME/.local/bin/$cosign_binary.sig" || exit 1

echo "==> Download oh-my-posh"
wget -q "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/$posh_binary.sig" -O "$HOME/.local/bin/$posh_binary.sig" || exit 1
wget -q "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/$posh_binary" -O "$HOME/.local/bin/$posh_binary" && chmod +x "$HOME/.local/bin/$posh_binary" || exit 1

echo "==> Verify oh-my-posh signature"
if cosign verify-blob --key "$HOME/.shell/cosign/oh-my-posh.pub" --signature "$HOME/.local/bin/$posh_binary.sig" "$HOME/.local/bin/$posh_binary"; then
  mv "$HOME/.local/bin/$posh_binary" "$HOME/.local/bin/oh-my-posh"
  rm "$HOME/.local/bin/$posh_binary.sig"
else
  exit 1
fi

echo "==> Link config files"
files=(
  .bashrc
  .config/helix/config.toml
  .digrc
  .gnupg/gpg-agent.conf
  .gnupg/gpg.conf
  .gnupg/scdaemon.conf
  .profile
  .vim/colors/onehalfdark.vim
  .vimrc
)

for file in "${files[@]}"; do
  ln -s "$HOME/.shell/$file" "$HOME/$file"
done

