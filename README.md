# DevOps Shell Environment

A curated set of tools and configurations designed to enhance your Bash shell environment on **Ubuntu** and **macOS**, specifically tailored for DevOps workflows and productivity.

## Screenshots

### Shell

![DevOps Shell](https://lab5.ca/_static/github/devops-shell.png)

### Vim

![Vim](https://lab5.ca/_static/github/devops-vim.png)

## Tools Installed

This project installs and configures the following tools:

- [Ansible-lint](https://ansible-lint.readthedocs.io/) (linter for Ansible playbooks)
- [Ansible](https://www.ansible.com/) (automation platform for IT operations)
- [Bash](https://www.gnu.org/software/bash/) (GNU Bourne Again SHell)
- [curl](https://curl.se/) (command-line tool for transferring data using various protocols)
- [Docker](https://www.docker.com/) (container runtime)
- [Git](https://git-scm.com/) (distributed version control system)
- [GitHub CLI](https://cli.github.com/) (gh)
- [Glow](https://github.com/charmbracelet/glow) (markdown renderer for CLI)
- [Google Cloud SDK](https://cloud.google.com/sdk) (gcloud)
- [GPG](https://gnupg.org/) (GNU Privacy Guard)
- [Helm](https://helm.sh/) (package manager for Kubernetes)
- [kubectl](https://kubernetes.io/docs/reference/kubectl/) (Kubernetes CLI)
- [Mods](https://github.com/charmbracelet/mods) (AI for the command line)
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/) (NVIDIA GPU-accelerated containers)
- [Oh My Posh](https://ohmyposh.dev/) (prompt theme engine)
- [Ollama](https://ollama.ai/) (CLI for Ollama API)
- [pass](https://www.passwordstore.org/) (Unix password manager)
- [pipx](https://pypa.github.io/pipx/) (Python package installer)
- [Terraform](https://www.terraform.io/) (Infrastructure as Code)
- [tree](http://mama.indstate.edu/users/ice/tree/) (directory listing)
- [unzip](https://infozip.sourceforge.net/UnZip.html) (extraction utility for ZIP archives)
- [VHS](https://github.com/charmbracelet/vhs) (CLI tool for recording terminal GIFs)
- [Vim](https://www.vim.org/) (Vi IMproved text editor)
- [Visual Studio Code](https://code.visualstudio.com/) (A free, open-source code editor with built-in debugging support, Git integration, and extensive customization options)
- [zfs-autobackup](https://github.com/psy0rz/zfs_autobackup) (A tool for automatically creating, rotating, and replicating ZFS snapshots)

## Installation

1. Clone the repository:

   ```bash
   cd $HOME
   git clone https://github.com/kborovik/.shell.git
   ```

2. Run the installation script:

   ```bash
   cd .shell
   make core-tools
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
