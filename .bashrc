#!/usr/bin/env bash
# shellcheck source=/dev/null

[ -z "$PS1" ] && return

HISTCONTROL="erasedups:ignoreboth"
HISTSIZE=10000
PROMPT_COMMAND="history -n; history -w; history -c; history -r"

export_dirs=(
  ~/.local/bin
  ~/.cargo/bin
  ~/go/bin
  ~/bin
  /opt/homebrew/opt/make/libexec/gnubin
  /opt/homebrew/opt/openssl@3/bin
  /opt/homebrew/opt/coreutils/libexec/gnubin
  /opt/homebrew/bin
  /opt/homebrew/sbin
  /usr/local/opt/make/libexec/gnubin
  /usr/local/opt/openssl@3/bin
  /usr/local/opt/coreutils/libexec/gnubin
  /usr/local/bin
  /usr/local/sbin
)
for dir in "${export_dirs[@]}"; do
  [ -d "$dir" ] && export PATH="$dir:$PATH"
done

export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

export COLORTERM="truecolor"
export EDITOR="vim"
export LESS="-R -F -i"
export MORE="-s"
export PAGER="less"

[ "$(command -v stty)" ] && stty -ixon

set -o noclobber

shopt -s autocd
shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dirspell
shopt -s histappend
shopt -s histreedit
shopt -s histverify
shopt -s hostcomplete
shopt -s nocaseglob

bind '"\C-d": complete-filename'
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

alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gd='git difftool'
alias gl='git pull'
alias glo='git log --pretty=format:'\''%C(auto)%h%d%Creset %C(cyan)(%cr)%Creset %C(green)%cn %Creset %s'\'''
alias gloa='git log --graph --all --pretty=format:'\''%C(auto)%h%d%Creset %C(cyan)(%cr)%Creset %C(green)%cn %Creset %s'\'''
alias gp='git push'
alias gst='git status'
alias la='ls -ha'
alias ll='ls -hlF'
alias ls='ls --color=auto'

typeset -a completion_files=(
  /usr/share/bash-completion/bash_completion
  /opt/homebrew/etc/profile.d/bash_completion.sh
  /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc
)
for file in "${completion_files[@]}"; do
  [ -r "$file" ] && source "$file"
done

[ "$(command -v cosign)" ] && eval "$(cosign completion bash)"
[ "$(command -v dircolors)" ] && eval "$(dircolors)"
[ "$(command -v gh)" ] && eval "$(gh completion -s bash)"
[ "$(command -v helm)" ] && eval "$(helm completion bash)"
[ "$(command -v kubectl)" ] && eval "$(kubectl completion bash)"
[ "$(command -v pip)" ] && eval "$(pip completion --bash)"
[ "$(command -v terraform)" ] && complete -C terraform terraform

source ~/.shell/.bash-functions.sh

[ "$(command -v oh-my-posh)" ] && eval "$(oh-my-posh init bash --config ~/.shell/onehalf.minimal.omp.json)"
