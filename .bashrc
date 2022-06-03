[ -z "$PS1" ] && return

tac "$HISTFILE" | awk '!x[$0]++' | tac >"${HISTFILE}~" && mv "${HISTFILE}~" "$HISTFILE"

export HISTCONTROL="erasedups:ignoreboth"
export HISTSIZE=10000
export HISTFILESIZE=10000
export PROMPT_COMMAND="history -n; history -w; history -c; history -r"

export PATH="$PATH:$HOME/.local/bin:$HOME/go/bin:/usr/local/go/bin"
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

export EDITOR="vim"
export LESS="-R -F -i"
export MORE="-s"
export PAGER="less"

if [ "$(command -v gpg)" ]; then
  export GPG_TTY=$(tty)
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
  gpg-connect-agent updatestartuptty /bye >/dev/null
fi

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

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'
bind 'set colored-stats on'
bind 'set completion-ignore-case on'
bind 'set completion-map-case on'
bind 'set show-all-if-ambiguous on'

alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gd='git diff'
alias gl='git pull'
alias glo='git log --all --pretty=format:'\''%C(auto)%h%d%Creset %C(cyan)(%cr)%Creset %C(green)%cn %Creset %s'\'''
alias gp='git push'
alias gst='git status'
alias la='ls -hld .*'
alias ll='ls -hlF'
alias ls='ls --color=auto'

if [ -f /usr/share/bash-completion/bash_completion ]; then
  source /usr/share/bash-completion/bash_completion
fi

complete -C /usr/bin/terraform terraform

[ "$(command -v dircolors)" ] && eval "$(dircolors)"
[ "$(command -v gh)" ] && eval "$(gh completion -s bash)"
[ "$(command -v helm)" ] && eval "$(helm completion bash)"
[ "$(command -v kubectl)" ] && eval "$(kubectl completion bash)"
[ "$(command -v lesspipe)" ] && eval "$(lesspipe)"
[ "$(command -v oh-my-posh)" ] && eval "$(oh-my-posh init bash --config ~/.shell/onehalf.minimal.omp.json)"
[ "$(command -v yq)" ] && eval "$(yq shell-completion bash)"
