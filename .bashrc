[[ $- != *i* ]] && return

path_dirs=(
  /usr/lib/go-1.21/bin
  ~/.nodenv/bin/
  ~/.nodenv/shims
  ~/.awscliv2/v2/current/bin
  ~/.krew/bin
  ~/.cargo/bin
  ~/go/bin
  ~/.local/bin
)
for dir in "${path_dirs[@]}"; do
  [ -d "$dir" ] && export PATH="$dir:$PATH"
done

completion_files=(
  /usr/share/bash-completion/bash_completion
)
for file in "${completion_files[@]}"; do
  [ -r "$file" ] && source "$file"
done

if [ -x /opt/homebrew/bin/brew ]; then

  eval "$(/opt/homebrew/bin/brew shellenv)"

  path_dirs=(
    ${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin
    ${HOMEBREW_PREFIX}/opt/make/libexec/gnubin
    ${HOMEBREW_PREFIX}/opt/openssl@3/bin
  )
  for dir in "${path_dirs[@]}"; do
    [ -d "$dir" ] && export PATH="$dir:$PATH"
  done

  completion_files=(
    ${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh
    ${HOMEBREW_PREFIX}/share/google-cloud-sdk/path.bash.inc
  )
  for file in "${completion_files[@]}"; do
    [ -r "$file" ] && source "$file"
  done

fi

export COLORTERM="truecolor"
export EDITOR="vim"
export HISTCONTROL="ignoreboth:erasedups"
export HISTFILESIZE=10000
export HISTSIZE="${HISTFILESIZE}"
export LESS="-R -F -i"
export MORE="-s"
export PAGER="less"
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"

set -o noclobber

shopt -s autocd
shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dirspell
shopt -s histreedit
shopt -s histverify
shopt -s hostcomplete
shopt -s nocaseglob

bind '"\C-f": complete-filename'
bind '"\C-h": backward-kill-word'
bind '"\e[1;3C": end-of-line'
bind '"\e[1;3D": beginning-of-line'
bind '"\e[1;5C": forward-word'
bind '"\e[1;5D": backward-word'
bind '"\e[3;3~": kill-word'
bind '"\e[3;5~": kill-word'
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e\C-?": unix-filename-rubout'

bind 'set colored-stats on'
bind 'set completion-ignore-case on'
bind 'set completion-map-case on'
bind 'set show-all-if-ambiguous on'

alias gaa='git add --all'
alias gc='git commit'
alias gd='git difftool'
alias gl='git fetch --all --prune --tags --prune-tags'
alias gk='git pull --all --prune --tags'
alias glo='git log --pretty=format:'\''%C(auto)%h%d%Creset %C(cyan)(%cr)%Creset %C(green)%cn %Creset %s'\'''
alias gloa='git log --graph --all --pretty=format:'\''%C(auto)%h%d%Creset %C(cyan)(%cr)%Creset %C(green)%cn %Creset %s'\'''
alias gp='git push'
alias gst='git status'
alias la='ls -ha'
alias ll='ls -hlF'
alias ls='ls --color=auto'

[ "$(command -v dircolors)" ] && eval "$(dircolors)"

[ -f ~/.shell/bash-functions.sh ] && source ~/.shell/bash-functions.sh

if [ -f ~/.bash-preexec.sh -a "$(command -v atuin)" ]; then
  source ~/.bash-preexec.sh
  eval "$(atuin init --disable-up-arrow bash)"
fi

[ "$(command -v oh-my-posh)" ] && eval "$(oh-my-posh init bash --config ~/.shell/onehalf.minimal.omp.json)"
