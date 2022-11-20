# shellcheck disable=SC2148
# shellcheck disable=SC2155
# shellcheck source=/dev/null

if [ -n "$BASH_VERSION" ]; then
  [ -f "$HOME/.bashrc" ] && source "$HOME/.bashrc"
fi

