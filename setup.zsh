#!/bin/zsh

# CHECK OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then 

#======================================
#  
#   _     ___ _   _ _   ___  __
#  | |   |_ _| \ | | | | \ \/ /
#  | |    | ||  \| | | | |\  / 
#  | |___ | || |\  | |_| |/  \ 
#  |_____|___|_| \_|\___//_/\_\
#                              
# 
#======================================

# Initialize an empty string to store the results
results=""

# Check if curl is installed
if ! command -v curl &> /dev/null
then
  echo "curl could not be found. Installing curl..."
  sudo apt install curl -y
  if [ $? -eq 0 ]; then
    results+="curl was installed successfully.\n"
  else
    results+="curl was not installed successfully.\n"
  fi
fi

# Update packages
sudo apt update -y && sudo apt upgrade -y
if [ $? -eq 0 ]; then
    results+="System update was successful.\n"
else
    results+="System update was not successful.\n"
fi

# Install build-essential for C compiler
sudo apt install build-essential -y
if [ $? -eq 0 ]; then
    results+="build-essential was installed successfully.\n"
else
    results+="build-essential was not installed successfully.\n"
fi

# Install oh-my-zsh
RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
if [ $? -eq 0 ]; then
    results+="oh-my-zsh was installed successfully.\n"
else
    results+="oh-my-zsh was not installed successfully.\n"
fi

# Set ZSH_CUSTOM
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

# Install Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
if [ $? -eq 0 ]; then
    results+="Powerlevel10k was installed successfully.\n"
else
    results+="Powerlevel10k was not installed successfully.\n"
fi

# Install zsh-syntax-highlighting plugin
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
if [ $? -eq 0 ]; then
    results+="zsh-syntax-highlighting was installed successfully.\n"
else
    results+="zsh-syntax-highlighting was not installed successfully.\n"
fi

# Install zsh-autosuggestions plugin
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
if [ $? -eq 0 ]; then
    results+="zsh-autosuggestions was installed successfully.\n"
else
    results+="zsh-autosuggestions was not installed successfully.\n"
fi

# Install packages
sudo apt install -y --no-install-recommends zsh htop fonts-firacode bat fzf thefuck fd-find howdoi
if [ $? -eq 0 ]; then
    results+="Required packages were installed successfully.\n"
else
    results+="Required packages were not installed successfully.\n"
fi

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
if [ $? -eq 0 ]; then
    results+="Rust was installed successfully.\n"
else
    results+="Rust was not installed successfully.\n"
fi

#  Source cargo
source "$HOME/.cargo/env"

# Clone exa repository
git clone https://github.com/ogham/exa.git
if [ $? -eq 0 ]; then
    results+="exa repository was cloned successfully.\n"
else
    results+="exa repository was not cloned successfully.\n"
fi

# Build exa
cd exa
cargo build --release
if [ $? -eq 0 ]; then
    results+="exa was built successfully.\n"
else
    results+="exa was not built successfully.\n"
fi

# Install exa
sudo mv target/release/exa /usr/local/bin/
if [ $? -eq 0 ]; then
    results+="exa was installed successfully.\n"
else
    results+="exa was not installed successfully.\n"
fi
cd ..

# Install zoxide
curl -LSfs https://raw.githubusercontent.com/ajeetdsouza/zoxide/master/install.sh | sh -s -- -b $HOME/.local/bin
echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.zshrc
source ~/.zshrc
if [ $? -eq 0 ]; then
    results+="zoxide was installed successfully.\n"
else
    results+="zoxide was not installed successfully.\n"
fi

# Backup existing configuration files if they exist
[[ -f ~/.zshrc ]] && cp ~/.zshrc ~/.zshrc.bak
[[ -f ~/.p10k.zsh ]] && cp ~/.p10k.zsh ~/.p10k.zsh.bak

# Copy configuration files
cp .zshrc ~/
cp .p10k.zsh ~/

# Source the new .zshrc file
source ~/.zshrc
if [ $? -eq 0 ]; then
    results+="Configuration files were sourced successfully.\n"
else
    results+="Configuration files were not sourced successfully.\n"
fi

# At the end of the script, print all the results
echo -e $results

#======================================
# 
#                         ___  ____  
#   _ __ ___   __ _  ___ / _ \/ ___| 
#  | '_ ` _ \ / _` |/ __| | | \___ \ 
#  | | | | | | (_| | (__| |_| |___) |
#  |_| |_| |_|\__,_|\___|\___/|____/ 
#                                    
# 
#=======================================

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