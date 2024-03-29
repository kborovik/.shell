#!/usr/bin/env bash

set -e

cosign_ver="v1.13.1"
posh_ver="v19.13.0"

dirs=(
  ~/.config/Code/User
  ~/.config/k9s/skins
  ~/.gnupg
  ~/.local/bin
  ~/.local/share/bash-completion
  ~/bin
  ~/tmp
)
mkdir -p "${dirs[@]}"

arch=""
case $(uname -m) in
amd64) arch="amd64" ;;
arm64) arch="arm64" ;;
x86_64) arch="amd64" ;;
esac

cosign_binary="cosign-$(uname)-$arch"
posh_binary="posh-$(uname)-$arch"

if [ ! -x "$HOME/bin/cosign" ] || [ ! -f "$HOME/bin/$cosign_binary.sig" ]; then
  echo "==> Download cosign"
  wget -q "https://github.com/sigstore/cosign/releases/download/$cosign_ver/$cosign_binary.sig" -O "$HOME/bin/$cosign_binary.sig"
  wget -q "https://github.com/sigstore/cosign/releases/download/$cosign_ver/$cosign_binary" -O "$HOME/bin/cosign" && chmod +x "$HOME/bin/cosign"
fi

echo "==> Verify cosign signature"
~/bin/cosign verify-blob --key "$HOME/.shell/cosign/cosign.pub" --signature "$HOME/bin/$cosign_binary.sig" "$HOME/bin/cosign" || exit 1

echo "==> Download oh-my-posh"
wget -q "https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/$posh_ver/$posh_binary.sig" -O "$HOME/bin/$posh_binary.sig"
wget -q "https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/$posh_ver/$posh_binary" -O "$HOME/bin/$posh_binary" && chmod +x "$HOME/bin/$posh_binary"

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
  .config/Code/User/keybindings.json
  .config/Code/User/settings.json
  .config/k9s/config.yaml
  .config/k9s/hotkeys.yaml
  .config/k9s/aliases.yaml
  .config/k9s/skins/onedark.yaml
  .digrc
  .gnupg/gpg-agent.conf
  .gnupg/gpg.conf
  .gnupg/scdaemon.conf
  .profile
  .vimrc
)
for file in "${files[@]}"; do
  ln -v -s -r -f "$HOME/.shell/$file" "$HOME/$file"
done

ln -v -s -r -f "$HOME/.shell/.vim" "$HOME"
ln -v -s -r -f "$HOME/.shell/bash-completion/completions" "$HOME/.local/share/bash-completion"

