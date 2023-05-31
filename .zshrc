# ============================================================================================ #
#                                                                                              #
#   _     ___ _____ _____   _________  _   _ ____   ____    ____ ___  _   _ _____ ___ ____     #
#  | |   |_ _|_   _| ____| |__  / ___|| | | |  _ \ / ___|  / ___/ _ \| \ | |  ___|_ _/ ___|    #
#  | |    | |  | | |  _|     / /\___ \| |_| | |_) | |     | |  | | | |  \| | |_   | | |  _     #
#  | |___ | |  | | | |___   / /_ ___) |  _  |  _ <| |___  | |__| |_| | |\  |  _|  | | |_| |    #
#  |_____|___| |_| |_____| /____|____/|_| |_|_| \_\\____|  \____\___/|_| \_|_|   |___\____|    #
#                                                                                              #
#                                                                                              #
# ============================================================================================ #
echo "LETS GO"

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =============================== #
#  PATH AND THEME CONFIGURATION   #
# =============================== #

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Use powerlevel10k theme
ZSH_THEME="powerlevel10k/powerlevel10k" # Use powerlevel10k theme

# ====================================== #
# AUTOCOMPLETE AND UPDATE CONFIGURATION  #
# ====================================== #

# Allow hyphens in autocomplete
HYPHEN_INSENSITIVE="true"

# just remind me to update when it's time
zstyle ':omz:update' mode reminder

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"

# ============================== #
#     POWERLEVEL10K CONFIG       #
# ============================== #
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

# ============================== #
#     PLUGIN CONFIGURATION       #
# ============================== #

# list of oh-my-zsh plugins
plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
  web-search
  alias-finder
  aliases
  command-not-found
  copypath
  copyfile
  macos
)

# source oh-my-zsh
source $ZSH/oh-my-zsh.sh

# ============================== #
#     PROMPT CONFIGURATION       #
# ============================== #

autoload -Uz vcs_info
precmd() {
    vcs_info
}
zstyle ':vcs_info:git:*' formats '(%b)'
setopt prompt_subst
PROMPT='%F{cyan}%n%f@%F{green}%m%f:%F{yellow}%~%f ${vcs_info_msg_0_}'

# ============================== #
#           DUMB SHIT            #
# ============================== #
alias bro='echo you got it bro && sudo $(fc -ln -1)' # Run last command with sudo
alias cat='bat --paging=never --tabs=4'
alias vim='nano'

# ============================== #
#    APP SPECIFIC ALIASES        #
# ============================== #

alias ls='exa -labh --group-directories-first --no-permissions --no-filesize --color always --sort=type' # better ls
alias code='open -a "Visual Studio Code"' # Open VS Code from anywhere
alias dockerps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Image}}\t{{.Ports}}"' # List running docker containers

# ============================== #
#        GENERAL ALIASES         #
# ============================== #

alias reload='source ~/.zshrc' # Reload .zshrc file
alias c='clear' # Clear terminal display
alias h='history' # Display history
alias ..='cd ..' # Go back 1 directory level (for fast typers)
alias ...='cd ../..' # Go back 2 directory levels
alias ....='cd ../../..' # Go back 3 directory levels
alias .....='cd ../../../..' # Go back 4 directory levels
alias update='sudo softwareupdate -i -a; brew update; brew upgrade' # Update macOS and Homebrew packages
alias cleanup='brew cleanup; rm -rf ~/Library/Caches/*' # Cleanup Homebrew and system caches
alias rm='rm -i' # Prompt before removing files
alias cp='cp -i' # Prompt before overwriting files with cp
alias mv='mv -i' # Prompt before overwriting files with mv
alias myip='curl http://ipecho.net/plain; echo' # Get public IP address
alias myips='ipconfig getifaddr en0 && ipconfig getifaddr en1'  # Get local IP addresses
alias pingg='ping google.com'  # Check internet connection

# ============================== #
#           FUNCTIONS            #
# ============================== #

function vnc() {
    if [[ -n "$SSH_CLIENT" ]]; then
        ip=$(echo $SSH_CLIENT | awk '{ print $1}')
        open vnc://$ip
    else
        echo "Not connected via SSH"
    fi
}

# ============================== #
#     PLUGIN INITIALIZATION      #
# ============================== #

# Initialize plugins
export PATH="$HOME/.local/bin:$PATH"
eval "$(zoxide init zsh)" # zoxide

# ============================== #
#              IDK               #
# ============================== #
