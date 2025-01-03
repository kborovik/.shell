[[ $- != *i* ]] && return

path_dirs=(
  ~/.atuin/bin
  ~/.local/bin
  ~/go/bin
  ~/.cargo/bin
  ~/.krew/bin
  ~/.awscliv2/v2/current/bin
  ~/.nodenv/shims
  ~/.nodenv/bin
)

for dir in "${path_dirs[@]}"; do
  if [[ -d "$dir" && ":$PATH:" != *":$dir:"* ]]; then
    PATH="$dir:$PATH"
  fi
done
export PATH

completion_files=(
  /usr/share/bash-completion/bash_completion
  /etc/bash_completion
)
for file in "${completion_files[@]}"; do
  if [ -r "$file" ]; then
    source "$file"
    break
  fi
done

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"

  path_dirs=(
    "${HOMEBREW_PREFIX}/opt/openssl@3/bin"
    "${HOMEBREW_PREFIX}/opt/make/libexec/gnubin"
    "${HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnubin"
    "${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin"
  )
  for dir in "${path_dirs[@]}"; do
    if [[ -d "$dir" && ":$PATH:" != *":$dir:"* ]]; then
      PATH="$dir:$PATH"
    fi
  done
  export PATH

  completion_files=(
    "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
    "${HOMEBREW_PREFIX}/share/google-cloud-sdk/path.bash.inc"
    "/usr/local/etc/bash_completion"
    "/etc/bash_completion"
  )

  for file in "${completion_files[@]}"; do
    if [[ -r "$file" ]]; then
      source "$file"
      break
    fi
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
alias gs='git difftool --staged'
alias gj='git difftool HEAD..origin/HEAD'
alias gl='git fetch --all --tags'
alias gk='git pull --all --tags'
alias glo='git log --pretty=format:'\''%C(auto)%h%d%Creset %C(cyan)(%cr)%Creset %C(green)%cn %Creset %s'\'''
alias gloa='git log --graph --all --pretty=format:'\''%C(auto)%h%d%Creset %C(cyan)(%cr)%Creset %C(green)%cn %Creset %s'\'''
alias gp='git push'
alias gst='git status'
alias la='ls -ha'
alias ll='ls -hlF'
alias ls='ls --color=auto'

[[ -f ~/.shell/bash-functions.sh ]] && source ~/.shell/bash-functions.sh

[[ "$(command -v nodenv)" ]] && eval "$(nodenv init - bash)"

[[ "$(command -v oh-my-posh)" ]] && eval "$(oh-my-posh init bash --config ~/.shell/onehalf.minimal.omp.json)"

if [[ -f ~/.bash-preexec.sh && "$(command -v atuin)" ]]; then
  if [[ "$(uname)" == "Linux" ]]; then
    atuin_dir="${HOME}/.local/share/atuin"
    [[ ! -d ${atuin_dir} ]] && mkdir -p ${atuin_dir}
    [[ ! $(findmnt -n ${atuin_dir}) ]] && mount ${atuin_dir}
  fi
  source ~/.bash-preexec.sh
  eval "$(atuin init --disable-up-arrow bash)"
fi
