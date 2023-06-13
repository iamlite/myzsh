# Lite Zshrc Setup

This repository contains my personal Zsh setup, optimized for macOS. It includes configurations for Oh My Zsh, Powerlevel10k, and several useful command-line tools, fonts, and brew packages. While this setup is primarily designed for macOS, it can be adapted for Linux with some modifications.

## Features

- **Oh My Zsh**: An open-source, community-driven framework for managing your Zsh configuration. It comes bundled with a ton of helpful functions, helpers, plugins, and themes.
- **Powerlevel10k**: A fast and customizable Zsh theme with prompt that supports powerline fonts and other features for a better terminal experience.
- **Fonts**: This setup includes the Fira Code and Hack Nerd fonts, which are particularly well-suited for coding due to their clear, distinct characters and coding ligatures.
- **Brew Packages**: A collection of useful brew packages such as `bat`, `fzf`, `jump`, `mpdecimal`, `pcre`, `six`, `zoxide`, `ca-certificates`, `go`, `libgit2`, `navi`, `pygments`, `sqlite`, `zsh`, `exa`, `howdoi`, `libssh2`, `ncurses`, `python@3.11`, `thefuck`, `fd`, `htop`, `mas`, `openssl@1.1`, `readline`, and `xz`.
- **Zsh Plugins**: This setup includes the `zsh-syntax-highlighting` and `zsh-autosuggestions` plugins, which provide syntax highlighting and command autosuggestions in the terminal.

## Installation

To install this setup, follow these steps:

1. Clone the repository:

```zsh
git clone https://github.com/iamlite/myzsh
```

2. Navigate to the cloned directory:

```zsh
cd myzsh
```

3. Permissions
```
chmod +x setup.zsh
```

4. Run the setup script:

```zsh
./setup.zsh
```

5. reload stuff
```
source ~/.zshrc
```

This will install all the necessary components and configure your Zsh environment.

Please note that this setup script will overwrite your existing `.zshrc` and `.p10k.zsh` files. It will create backups of your existing files with a `.bak` extension.

## Customization

Feel free to fork this repository and customize it to suit your needs. If you're using Linux, you may need to modify the setup script and the Zsh configuration to work with your specific distribution and environment.
