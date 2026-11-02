#!/bin/zsh
# ============================================================================
# myzsh setup — idempotent installer
#
# Safe to re-run: existing dotfiles are backed up (timestamped) before being
# replaced, components that are already installed are skipped, and nothing is
# removed. Backups land in ~/.myzsh-backups/<timestamp>/.
#
# What it does:
#   1. Installs oh-my-zsh, the Powerlevel10k theme and the two custom plugins
#      (only if missing)
#   2. Installs the CLI tools the config uses (bat, eza, fzf, zoxide, fd,
#      ripgrep, git-delta, atuin, mise, pay-respects), plus Starship and a
#      Nerd Font (macOS/Homebrew; best-effort + hints on Linux)
#   2b. Points git at delta as its pager (only if no pager is configured yet;
#      ~/.gitconfig is backed up first)
#   3. Copies .zshrc, .zprofile, .p10k.zsh and starship.toml into place
# ============================================================================

SETUP_DIR="${0:A:h}"
typeset -a SUMMARY
BACKUP_DIR=""

say_ok()   { print -r -- "  ✓ $1"; SUMMARY+=("✓ $1") }
say_skip() { print -r -- "  – $1"; SUMMARY+=("– $1") }
say_fail() { print -r -- "  ✗ $1"; SUMMARY+=("✗ $1") }

backup_file() {
  local f="$1"
  [[ -e "$f" ]] || return 0
  if [[ -z "$BACKUP_DIR" ]]; then
    BACKUP_DIR="$HOME/.myzsh-backups/$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$BACKUP_DIR" || return 1
  fi
  cp "$f" "$BACKUP_DIR/" && say_ok "backed up $f → $BACKUP_DIR/"
}

install_file() {
  local src="$1" dst="$2"
  if [[ ! -f "$src" ]]; then
    say_fail "source file missing: $src"
    return
  fi
  mkdir -p "${dst:h}"
  # A stale symlink gets replaced (its target is never touched)
  if [[ -L "$dst" ]]; then
    rm "$dst"
    say_skip "$dst was a symlink — replaced with a real copy"
  fi
  if [[ -f "$dst" ]] && cmp -s "$src" "$dst"; then
    say_skip "$dst is already up to date"
    return
  fi
  backup_file "$dst"
  if cp "$src" "$dst"; then
    say_ok "installed $dst"
  else
    say_fail "could not install $dst"
  fi
}

clone_if_missing() {
  local dir="$1" url="$2" label="$3"
  if [[ -d "$dir" ]]; then
    say_skip "$label already installed"
  elif git clone --depth=1 "$url" "$dir" &>/dev/null; then
    say_ok "installed $label"
  else
    say_fail "could not clone $label ($url)"
  fi
}

print -r -- "== myzsh setup (from $SETUP_DIR) =="

# ---------------------------------------------------------------- preflight
if ! command -v git &>/dev/null; then
  print -r -- "git is required but was not found. Install git first, then re-run."
  exit 1
fi

# ------------------------------------------------------- oh-my-zsh + plugins
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [[ -d "$HOME/.oh-my-zsh" ]]; then
  say_skip "oh-my-zsh already installed"
elif command -v curl &>/dev/null; then
  if RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended &>/dev/null; then
    say_ok "installed oh-my-zsh"
  else
    say_fail "oh-my-zsh install failed"
  fi
else
  say_fail "curl not found — cannot install oh-my-zsh"
fi

clone_if_missing "$ZSH_CUSTOM_DIR/themes/powerlevel10k" \
  "https://github.com/romkatv/powerlevel10k.git" "Powerlevel10k theme"
# fast-syntax-highlighting replaces zsh-syntax-highlighting (mutually
# exclusive — the config enables only fast-syntax-highlighting)
clone_if_missing "$ZSH_CUSTOM_DIR/plugins/fast-syntax-highlighting" \
  "https://github.com/zdharma-continuum/fast-syntax-highlighting.git" "fast-syntax-highlighting"
clone_if_missing "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions" \
  "https://github.com/zsh-users/zsh-autosuggestions" "zsh-autosuggestions"

# --------------------------------------------------------------------- tools
if [[ "$OSTYPE" == darwin* ]]; then
  BREW=""
  for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [[ -x "$b" ]] && BREW="$b" && break
  done
  [[ -z "$BREW" ]] && BREW="$(command -v brew 2>/dev/null)"

  if [[ -z "$BREW" ]]; then
    say_fail "Homebrew not found — skipping tool installs. Install it from https://brew.sh, then re-run."
  else
    # CLI tools the config integrates with (all guarded in .zshrc)
    for pkg in bat eza fzf zoxide fd starship ripgrep git-delta atuin mise; do
      if PATH="${BREW:h}:$PATH" command -v "$pkg" &>/dev/null; then
        say_skip "$pkg already installed"
      elif "$BREW" install "$pkg" &>/dev/null; then
        say_ok "installed $pkg (brew)"
      else
        say_fail "brew install $pkg failed"
      fi
    done

    # pay-respects is not in homebrew-core — it lives in the author's tap.
    # Try core first (in case it lands there), then the tap.
    if PATH="${BREW:h}:$PATH" command -v pay-respects &>/dev/null; then
      say_skip "pay-respects already installed"
    elif "$BREW" install pay-respects &>/dev/null; then
      say_ok "installed pay-respects (brew)"
    elif "$BREW" install timescam/homebrew-tap/pay-respects &>/dev/null; then
      say_ok "installed pay-respects (brew, timescam tap)"
    else
      say_fail "brew install pay-respects failed (core and tap)"
    fi

    # fzf shell integration file (~/.fzf.zsh, sourced by .zshrc when present)
    if [[ -f "$HOME/.fzf.zsh" ]]; then
      say_skip "~/.fzf.zsh already present"
    elif [[ -x "$("$BREW" --prefix)/opt/fzf/install" ]]; then
      if "$("$BREW" --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc &>/dev/null; then
        say_ok "generated ~/.fzf.zsh"
      else
        say_fail "fzf integration script failed"
      fi
    fi

    # Nerd Fonts — the prompt glyphs need one. Terminal app must be set to it.
    for cask in font-meslo-lg-nerd-font font-hack-nerd-font; do
      if "$BREW" list --cask "$cask" &>/dev/null; then
        say_skip "$cask already installed"
      elif "$BREW" install --cask "$cask" &>/dev/null; then
        say_ok "installed $cask"
      else
        say_fail "brew install --cask $cask failed"
      fi
    done
  fi

elif [[ "$OSTYPE" == linux* ]]; then
  say_skip "Linux: skipping Homebrew steps"
  if command -v apt-get &>/dev/null && command -v sudo &>/dev/null; then
    for pkg in zsh git curl fzf ripgrep git-delta; do
      if command -v "$pkg" &>/dev/null; then
        say_skip "$pkg already installed"
      elif sudo apt-get install -y "$pkg" &>/dev/null; then
        say_ok "installed $pkg (apt)"
      else
        say_fail "apt install $pkg failed"
      fi
    done
  else
    say_skip "apt-get/sudo not available — install zsh, git, curl, fzf, ripgrep with your package manager"
  fi

  # Tools apt doesn't carry (or carries too old): official install scripts,
  # each guarded — skipped when the command already exists. These run before
  # the dotfiles below are installed, so any rc edits they make are moot.
  mkdir -p "$HOME/.local/bin"
  if command -v starship &>/dev/null; then
    say_skip "starship already installed"
  elif curl -fsSL https://starship.rs/install.sh | sh -s -- --yes --bin-dir "$HOME/.local/bin" &>/dev/null </dev/null; then
    say_ok "installed starship (official script, ~/.local/bin)"
  else
    say_fail "starship install script failed"
  fi
  if command -v mise &>/dev/null || [[ -x "$HOME/.local/bin/mise" ]]; then
    say_skip "mise already installed"
  elif curl -fsSL https://mise.run | sh &>/dev/null </dev/null; then
    say_ok "installed mise (official script, ~/.local/bin)"
  else
    say_fail "mise install script failed"
  fi
  if command -v atuin &>/dev/null; then
    say_skip "atuin already installed"
  elif curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh &>/dev/null </dev/null; then
    say_ok "installed atuin (official script)"
  else
    say_fail "atuin install script failed"
  fi
  if command -v pay-respects &>/dev/null; then
    say_skip "pay-respects already installed"
  elif curl -sSfL https://raw.githubusercontent.com/iffse/pay-respects/main/install.sh | sh &>/dev/null </dev/null; then
    say_ok "installed pay-respects (official script)"
  else
    say_fail "pay-respects install script failed"
  fi
  print -r -- "  – Linux hints: install eza, zoxide, fd and bat (bat is 'batcat' in Debian/Ubuntu)"
  print -r -- "    via your distro or cargo, and any Nerd Font (e.g. MesloLGS NF) for prompt glyphs."
fi

# ------------------------------------------------------------- git + delta
# Use delta as git's pager — only when delta exists AND no pager is already
# configured (never stomp an existing choice). ~/.gitconfig is backed up
# first whenever this changes it.
DELTA_BIN="$(command -v delta 2>/dev/null)"
if [[ -z "$DELTA_BIN" && -n "$BREW" && -x "${BREW:h}/delta" ]]; then
  DELTA_BIN="${BREW:h}/delta"
fi
if [[ -n "$DELTA_BIN" ]]; then
  if [[ -z "$(git config --global core.pager 2>/dev/null)" ]]; then
    backup_file "$HOME/.gitconfig"
    if git config --global core.pager delta \
       && git config --global interactive.diffFilter 'delta --color-only' \
       && git config --global delta.dark true \
       && git config --global delta.line-numbers true; then
      say_ok "configured git: core.pager=delta (dark, line-numbers)"
    else
      say_fail "setting git delta config failed"
    fi
  else
    say_skip "git core.pager already set — leaving git config alone"
  fi
else
  say_skip "delta not installed — git pager unchanged"
fi

# nvm — the config loads it if present; installing it is a one-liner, left manual on purpose
if [[ ! -d "$HOME/.nvm" && ! -d /opt/homebrew/opt/nvm && ! -d /usr/local/opt/nvm ]]; then
  print -r -- "  – nvm not found. To add it: curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash"
  print -r -- "    (the shell config works fine without it — node segments just stay hidden)"
fi

# --------------------------------------------------------------------- files
install_file "$SETUP_DIR/.zshrc"        "$HOME/.zshrc"
install_file "$SETUP_DIR/.zprofile"     "$HOME/.zprofile"
install_file "$SETUP_DIR/.p10k.zsh"     "$HOME/.p10k.zsh"
install_file "$SETUP_DIR/starship.toml" "$HOME/.config/starship.toml"

# ------------------------------------------------------------------- summary
print -r -- ""
print -r -- "== Summary =="
for line in "${SUMMARY[@]}"; do
  print -r -- "  $line"
done
[[ -n "$BACKUP_DIR" ]] && print -r -- "  Backups: $BACKUP_DIR"
print -r -- ""
print -r -- "Next steps:"
print -r -- "  1. Set your terminal font to a Nerd Font (MesloLGS NF or Hack Nerd Font)"
print -r -- "     or the prompt glyphs will show as boxes."
print -r -- "  2. Open a new terminal (or run: source ~/.zshrc)."
print -r -- "  3. Per-machine extras (tool paths, API keys):"
print -r -- "       cp \"$SETUP_DIR/zshrc.local.example\" ~/.zshrc.local"
