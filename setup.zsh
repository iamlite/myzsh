#!/bin/zsh

# CHECK OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then 

# Update packages
sudo apt update && sudo apt upgrade

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Install zsh-syntax-highlighting plugin
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install zsh-autosuggestions plugin
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install packages
sudo apt install -y bat fzf libpcre3-dev ca-certificates golang libgit2-dev sqlite3 zsh exa libssh2-1-dev libncurses5-dev thefuck fd-find htop libssl-dev libreadline-dev xz-utils fonts-firacode fonts-nerd-ttf

# Install zoxide
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/ajeetdsouza/zoxide/master/install.sh | sh

# Backup existing configuration files if they exist
[[ -f ~/.zshrc ]] && cp ~/.zshrc ~/.zshrc.bak
[[ -f ~/.p10k.zsh ]] && cp ~/.p10k.zsh ~/.p10k.zsh.bak

# Copy configuration files
cp .zshrc ~/
cp .p10k.zsh ~/

# Source the new .zshrc file
source ~/.zshrc


elif [[ "$OSTYPE" == "darwin"* ]]; then

# Update Zsh
brew upgrade zsh

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Install zsh-syntax-highlighting plugin
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install zsh-autosuggestions plugin
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install brew formulae
brew install bat fzf jump mpdecimal pcre six zoxide ca-certificates go libgit2 navi pygments sqlite zsh exa howdoi libssh2 ncurses python@3.11 thefuck fd htop mas openssl@1.1 readline xz

# Install brew casks
brew install --cask font-fira-code font-hack-nerd-font

# Backup existing configuration files if they exist
[[ -f ~/.zshrc ]] && cp ~/.zshrc ~/.zshrc.bak
[[ -f ~/.p10k.zsh ]] && cp ~/.p10k.zsh ~/.p10k.zsh.bak

# Copy configuration files
cp .zshrc ~/
cp .p10k.zsh ~/

# Source the new .zshrc file
source ~/.zshrc
fi