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

# ============================== #
#        PROMPT ENGINE           #
# ============================== #

# Which prompt engine to use: starship (default) or p10k (Powerlevel10k).
# Flip the default here, or per machine:  export PROMPT_ENGINE=p10k  in
# ~/.zshenv (machine-local, not tracked in git).
# If the chosen engine isn't installed, the other one takes over silently;
# if neither is installed, the plain built-in prompt further down applies.
PROMPT_ENGINE="${PROMPT_ENGINE:-starship}"
if [[ "$PROMPT_ENGINE" == "starship" ]] && (( ! $+commands[starship] )); then
  PROMPT_ENGINE="p10k"
elif [[ "$PROMPT_ENGINE" == "p10k" ]] && [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]] && (( $+commands[starship] )); then
  PROMPT_ENGINE="starship"
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# Only relevant when the p10k engine is active.
if [[ "$PROMPT_ENGINE" == "p10k" ]] && [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =============================== #
#  PATH AND THEME CONFIGURATION   #
# =============================== #

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# User-local binaries (e.g. zoxide installed from its own script lands here)
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

# Theme follows the prompt engine resolved above.
if [[ "$PROMPT_ENGINE" == "starship" ]]; then
  ZSH_THEME="" # No oh-my-zsh theme — Starship provides the prompt
elif [[ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]]; then
  ZSH_THEME="powerlevel10k/powerlevel10k" # Use powerlevel10k theme
else
  ZSH_THEME=""
fi

# Don't let Powerlevel10k nag about running its configuration wizard
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

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
#     PLUGIN CONFIGURATION       #
# ============================== #


# list of oh-my-zsh plugins
# fast-syntax-highlighting replaces zsh-syntax-highlighting (they're mutually
# exclusive — never enable both) and loads last, as its docs recommend.
plugins=( git zsh-autosuggestions web-search alias-finder aliases command-not-found copypath copyfile macos fast-syntax-highlighting )

# The oh-my-zsh fzf plugin prints an error at startup when fzf is missing,
# so it only joins the list when fzf actually exists.
(( $+commands[fzf] )) && plugins+=( fzf )

# source oh-my-zsh (only if it's actually installed)
[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# ============================== #
#     PROMPT CONFIGURATION       #
# ============================== #

# Built-in fallback prompt — used only when neither prompt engine is active.
# Both engines replace this when they load.
autoload -Uz vcs_info
precmd() {
    vcs_info
}
zstyle ':vcs_info:git:*' formats '(%b)'
setopt prompt_subst
PROMPT='%F{cyan}%n%f@%F{green}%m%f:%F{yellow}%~%f ${vcs_info_msg_0_}'

# ============================== #
#     PLUGIN INITIALIZATION      #
# ============================== #

# Initialize plugins — every hookup is guarded: if the tool is missing the
# shell starts silently instead of printing errors.
(( $+commands[zoxide] )) && eval "$(zoxide init zsh --cmd cd)" # zoxide — plain `cd` is the smart jump now
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Use fd as fzf's file finder when it's installed (fast, respects .gitignore).
# Keybindings don't change — Ctrl-T / Ctrl-R / Alt-C just get a better backend.
if (( $+commands[fd] )); then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

# atuin: searchable shell history — initialized AFTER fzf on purpose: it takes
# over Ctrl-R (and up-arrow) history search from fzf. Guarded like everything
# else; machines without atuin keep the fzf bindings.
(( $+commands[atuin] )) && eval "$(atuin init zsh)" # atuin

# pay-respects (the maintained thefuck successor): after a botched command,
# type `fuck` and it suggests the corrected one. The alias name is the whole
# point — it's the old thefuck workflow.
(( $+commands[pay-respects] )) && eval "$(pay-respects zsh --alias fuck)" # pay-respects

# ============================== #
#      GENERAL ALIASES           #
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
alias python="python3"
alias pip="pip3"
alias npr="npm run"

# ============================== #
#    APP SPECIFIC ALIASES        #
# ============================== #

# better ls: eza (the maintained successor of exa) where available,
# exa as a fallback, plain ls otherwise — decided by what exists.
if (( $+commands[eza] )); then
  alias ls='eza -labh --group-directories-first --no-permissions --no-filesize --color always --sort=type' # better ls
  alias tree='eza --tree' # directory tree
  alias exa='eza' # muscle-memory shim
elif (( $+commands[exa] )); then
  alias ls='exa -labh --group-directories-first --no-permissions --no-filesize --color always --sort=type' # better ls
  alias tree='exa --tree' # directory tree
fi
alias code='open -a "Visual Studio Code"' # Open VS Code from anywhere
alias dockerps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Image}}\t{{.Ports}}"' # List running docker containers

# ============================== #
#         DUMB SHIT              #
# ============================== #
alias bro='echo you got it bro && sudo $(fc -ln -1)' # Run last command with sudo
(( $+commands[bat] )) && alias cat='bat --paging=never --tabs=4'
alias vim='nano'

# ============================== #
#        P10K SOURCE             #
# ============================== #

# Powerlevel10k config — only when the p10k engine is active.
if [[ "$PROMPT_ENGINE" == "p10k" && -f ~/.p10k.zsh ]]; then
  source ~/.p10k.zsh
fi

# ============================== #
#         FUNCTIONS              #
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
#              NODE              #
# ============================== #

# nvm: load from ~/.nvm if present, otherwise from a Homebrew install.
# Deliberately does NOT call `$(brew --prefix nvm)`: a broken brew prints
# errors into every new shell before nvm even gets a chance to load
# (learned the hard way, Nov 2026). Probing fixed paths is silent either way.
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  source "$NVM_DIR/nvm.sh" # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion" # This loads nvm bash_completion
else
  for _nvm_home in /opt/homebrew/opt/nvm /usr/local/opt/nvm; do
    if [ -s "$_nvm_home/nvm.sh" ]; then
      source "$_nvm_home/nvm.sh" # This loads nvm
      [ -s "$_nvm_home/etc/bash_completion.d/nvm" ] && source "$_nvm_home/etc/bash_completion.d/nvm" # This loads nvm bash_completion
      break
    fi
  done
  unset _nvm_home
fi

# ============================== #
#              MISE              #
# ============================== #

# mise: one version manager for node/python/ruby/go/etc. Activated after the
# nvm block above, so on machines that have mise its shims win and nvm stays
# as the fallback for machines without it. Pin a machine's default node with:
#   mise use -g node@<version>
(( $+commands[mise] )) && eval "$(mise activate zsh)" # mise

# ============================== #
#           STARSHIP             #
# ============================== #

# Starship prompt — only when the starship engine is active.
# Config lives in ~/.config/starship.toml (installed by setup.zsh).
if [[ "$PROMPT_ENGINE" == "starship" ]] && (( $+commands[starship] )); then
  export TERM="xterm-256color" # Fix TERM for Starship
  eval "$(starship init zsh)"
fi

# ============================== #
#      MACHINE-LOCAL CONFIG      #
# ============================== #

# Per-machine tool paths, settings and secrets live in ~/.zshrc.local.
# It is NOT tracked in git — see zshrc.local.example in this repo.
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
