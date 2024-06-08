# Shell Prompt for DevOps

Shell Prompt for DevOps is the collection of tools for managing the Bash shell environment (Linux, macOS)

# Software

The `makefile` installs the following software packages

- `bash` dot files
- `vim` configuration
- `gpg` configuration
- `oh-my-posh` prompt theme engine https://ohmyposh.dev/
- `atuin` shell history https://atuin.sh/
- `mods` AI for the command line https://github.com/charmbracelet/mods
- `code` Visual Studio Code https://code.visualstudio.com/

# How to Use

Clone the repository into `$HOME` folder

```
cd $HOME
git clone https://github.com/kborovik/.shell.git
```

Run installation script

```
cd .shell
make install
```

Restart Bash

```
exec bash
```

# Prompt Theme Engine

The prompt theme engine is `Oh-My-Posh` (https://ohmyposh.dev/)

## Screenshots

# Terminal Color Schema

The color schema for `oh-my-posh`, `vim` and `k9s` is based on Atom "One Dark".
