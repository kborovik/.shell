# shellcheck disable=SC2148
# shellcheck disable=SC2155
# shellcheck source=/dev/null

[ -z "$PS1" ] && return

HISTCONTROL="erasedups:ignoreboth"
HISTSIZE=10000
PROMPT_COMMAND="history -n; history -w; history -c; history -r"

case $(uname) in
Linux)
  export PATH="${HOME}/go/bin:${PATH}"
  ;;
Darwin)
  export PATH="/opt/homebrew/opt/make/libexec/gnubin:/opt/homebrew/opt/openssl@3/bin:/opt/homebrew/opt/coreutils/libexec/gnubin:/opt/homebrew/bin:/opt/homebrew/sbin:/Users/kborovi/Library/Python/3.10/bin:${HOME}/go/bin:${PATH}"
  ;;
esac

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
bind 'set completion-ignore-case on'
bind 'set completion-map-case on'
bind 'set show-all-if-ambiguous on'

alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gd='git diff'
alias gl='git pull'
alias glo='git log --pretty=format:'\''%C(auto)%h%d%Creset %C(cyan)(%cr)%Creset %C(green)%cn %Creset %s'\'''
alias gloa='git log --all --pretty=format:'\''%C(auto)%h%d%Creset %C(cyan)(%cr)%Creset %C(green)%cn %Creset %s'\'''
alias gp='git push'
alias gst='git status'
alias la='ls -hld .*'
alias ll='ls -hlF'
alias ls='ls --color=auto'

typeset -a completion_path=(
  /usr/share/bash-completion/bash_completion
  /opt/homebrew/etc/profile.d/bash_completion.sh
  /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc
  ~/.bash_completion.d/python-argcomplete
)
for path in "${completion_path[@]}"; do
  [ -r "${path}" ] && source "${path}"
done

complete -C terraform terraform

[ "$(command -v azcopy)" ] && eval "$(azcopy completion bash)"
[ "$(command -v dircolors)" ] && eval "$(dircolors)"
[ "$(command -v gh)" ] && eval "$(gh completion -s bash)"
[ "$(command -v helm)" ] && eval "$(helm completion bash)"
[ "$(command -v kubectl)" ] && eval "$(kubectl completion bash)"
[ "$(command -v npm)" ] && eval "$(npm completion)"
[ "$(command -v pip)" ] && eval "$(pip completion --bash)"
[ "$(command -v pip3)" ] && eval "$(pip3 completion --bash)"
[ "$(command -v yq)" ] && eval "$(yq shell-completion bash)"

[ "$(command -v oh-my-posh)" ] && eval "$(oh-my-posh init bash --config ~/.shell/onehalf.minimal.omp.json)"
