#!/bin/zsh

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

# Copy configuration files
cp .zshrc ~/
cp .p10k.zsh ~/

# Source the new .zshrc file
source ~/.zshrc

