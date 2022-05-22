[ -z "$PS1" ] && return

HISTCONTROL="erasedups:ignoreboth"

export PATH="$PATH:$HOME/.local/bin:$HOME/go/bin:/usr/local/go/bin"
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

export EDITOR="vim"
export LESS="-R -F -i"
export MORE="-s"
export PAGER="less"

if [ -n "$(command -v gpg)" ]; then
  export GPG_TTY=$(tty)
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
  gpg-connect-agent updatestartuptty /bye >/dev/null
fi

set -o noclobber

shopt -s autocd
shopt -s cdable_vars
shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dirspell
shopt -s histappend
shopt -s histreedit
shopt -s histverify
shopt -s hostcomplete
shopt -s lithist
shopt -s nocaseglob

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'
bind 'set colored-completion-prefix off'
bind 'set colored-stats on'
bind 'set completion-ignore-case on'
bind 'set history-size 5000'
bind 'set show-all-if-ambiguous on'
bind 'set completion-map-case on'
bind 'set completion-ignore-case on'

alias ls='ls --color=auto'
alias ll='ls -ahlF'
alias la='ls -A'

alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gd='git diff'
alias gl='git pull'
alias glo='git log --all --pretty=format:'\''%C(auto)%h%d%Creset %C(cyan)(%cr)%Creset %C(green)%cn %Creset %s'\'''
alias gp='git push'
alias gst='git status'

if [ -f /usr/share/bash-completion/bash_completion ]; then
  source /usr/share/bash-completion/bash_completion
fi

complete -C /usr/bin/terraform terraform

eval "$(yq shell-completion bash)"
eval "$(gh completion -s bash)"
eval "$(dircolors)"
eval "$(lesspipe)"
eval "$(oh-my-posh init bash --config ~/.shell/onehalf.minimal.omp.json)"
