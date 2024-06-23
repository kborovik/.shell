# DevOps Shell Environment

A curated set of tools and configurations designed to enhance your Bash shell environment on Ubuntu and macOS, specifically tailored for DevOps workflows and productivity.

## Screenshots

### Shell

![DevOps Shell](https://lab5.ca/_static/github/devops-shell.png)

### Vim

![Vim](https://lab5.ca/_static/github/devops-vim.png)

## Features

This project includes configurations and installations for:

- Customized `bash` dot files
- Optimized `vim` setup
- Secure `gpg` configuration
- [Oh My Posh](https://ohmyposh.dev/) - A prompt theme engine
- [Atuin](https://atuin.sh/) - Magical shell history
- [Mods](https://github.com/charmbracelet/mods) - AI-powered command line tool
- [Visual Studio Code](https://code.visualstudio.com/) - Powerful code editor

## Installation

1. Clone the repository:

   ```bash
   cd $HOME
   git clone https://github.com/kborovik/.shell.git
   ```

2. Run the installation script:

   ```bash
   cd .shell
   make install
   ```

3. Restart your Bash session:

   ```bash
   exec bash
   ```

## Prompt Theme Engine

We use [Oh My Posh](https://ohmyposh.dev/) as the prompt theme engine, providing a customizable and informative command line experience.

## Color Scheme

The color scheme for `oh-my-posh`, `vim`, and `k9s` is based on Atom's "One Dark" theme, offering a consistent and pleasing visual experience across different tools.

## License

[MIT License](LICENSE)
```
