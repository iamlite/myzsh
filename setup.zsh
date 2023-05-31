#!/bin/zsh

# CHECK OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then 

  # Update packages
  sudo apt update && sudo apt upgrade -y

  # Install snap if not installed
  if ! command -v snap &> /dev/null
  then
    sudo apt install snapd -y
  fi

  # Install oh-my-zsh
  RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  # Set ZSH_CUSTOM
  ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

  # Install Powerlevel10k
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

  # Install zsh-syntax-highlighting plugin
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

  # Install zsh-autosuggestions plugin
  git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

  # Install packages
  sudo apt-get install -y --no-install-recommends libpcre3-dev ca-certificates sqlite3 zsh libssh2-1-dev libncurses5-dev htop libssl-dev libreadline-dev xz-utils fonts-firacode fonts-nerd-ttf

  # Install packages with snap
  sudo snap install bat fzf thefuck fd-find --classic

  # Install exa
  curl -LSfs https://github.com/ogham/exa/releases/download/v0.10.1/exa-linux-x86_64-v0.10.1.zip -o exa.zip
  unzip exa.zip
  sudo mv exa-linux-x86_64 /usr/local/bin/exa
  sudo rm exa.zip

  # Install zoxide
  curl -LSfs https://raw.githubusercontent.com/ajeetdsouza/zoxide/master/install.sh | sh -s -- -b $HOME/.local/bin

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