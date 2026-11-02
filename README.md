# Lite Zsh Setup

My personal zsh setup for macOS (Linux works too, with a few manual steps).
Oh My Zsh + a glyph-heavy prompt + the usual fast CLI replacements.

**Modernized November 2026.** The 2023 version had a bad habit: unguarded
tool hookups (looking at you, `source $(brew --prefix nvm)/nvm.sh`) that
printed errors into every new shell the moment a tool broke or went missing.
Every integration in this config is now guarded — if a tool isn't installed
or is broken, the shell starts silently and that feature just doesn't show.

## The prompt

Default engine is **Starship** (`starship.toml` in this repo): actively
maintained, and the same config works on macOS and Linux. The look is a
Gruvbox powerline chain — OS icon, user@host, directory, git branch/status,
language versions, docker/conda, clock — cloned from what I already ran on
the Studio. Everything the old Powerlevel10k setup showed is covered:

| Powerlevel10k | Starship |
| --- | --- |
| os_icon, context | `os`, `username` + `hostname` (SSH only) |
| dir | `directory` |
| vcs | `git_branch` + `git_status` |
| status, command_execution_time, background_jobs | right side: `status`, `cmd_duration`, `jobs` |
| direnv + version-manager segments | `direnv` (right side) + language modules |
| time | `time` |
| transient prompt | — (no Starship equivalent) |

**Powerlevel10k is kept as a fallback.** Flip one variable:

```zsh
# in .zshrc, or per machine in ~/.zshenv
export PROMPT_ENGINE=p10k   # default: starship
```

If the selected engine isn't installed, the other one takes over silently.

### Fonts (required for the glyphs)

The prompt uses Nerd Font icons. `setup.zsh` installs
**MesloLGS NF** (`font-meslo-lg-nerd-font`) and **Hack Nerd Font**
(`font-hack-nerd-font`) via Homebrew. You still have to point your terminal
app at one of them (Terminal.app / iTerm2 / etc. → font settings), or the
icons show up as boxes.

## Tools

Integrated in `.zshrc`, all behind `command -v` guards:

| Tool | Used for | Notes |
| --- | --- | --- |
| eza | `ls`, `tree` | Successor of the dead **exa** project; same flags. Falls back to exa, then plain `ls`. |
| bat | `cat` | |
| zoxide | `z` directory jumping | Replaced `jump` years ago. |
| fzf + fd | Ctrl-T / Ctrl-R / Alt-C | fd becomes fzf's backend when present (fast, respects `.gitignore`). Keys unchanged. |
| nvm | node versions | Loaded from `~/.nvm`, else from Homebrew's opt dir — probed by path, never via `$(brew --prefix …)`. |
| Homebrew | `update`/`cleanup` aliases, `.zprofile` | shellenv is loaded only if a brew binary actually exists. |

Dropped from the 2023 install lists: `exa` (dead → eza), `jump` (superseded
by zoxide), `thefuck` (unmaintained), `howdoi` (dead), `openssl@1.1` (EOL).

## Installation

```zsh
git clone https://github.com/iamlite/myzsh
cd myzsh
chmod +x setup.zsh
./setup.zsh
```

`setup.zsh` is idempotent — re-running it is the update mechanism
(`git pull && ./setup.zsh`). Before it replaces any dotfile it makes a
timestamped backup in `~/.myzsh-backups/`. It installs Oh My Zsh,
Powerlevel10k, the syntax-highlighting/autosuggestions plugins, the CLI
tools above, Starship, and the fonts. It does **not** install Homebrew or
nvm for you (it prints the one-liners if they're missing).

On Linux it does the same config/plugin steps, installs the basics with
apt where possible, and prints hints for the rest.

## Machine-local config: `.zshrc.local`

Anything machine-specific — extra tool PATHs (deno, flutter, bun, pnpm…),
API keys, secrets — lives in `~/.zshrc.local`, which `.zshrc` sources last
and git ignores. Copy the annotated starting point:

```zsh
cp zshrc.local.example ~/.zshrc.local
```

The example file contains the Studio's current tool-path blocks, all
existence-guarded so stale entries stay silent.

## Recommendations (not installed — my call, listed for future me)

- **ripgrep (`rg`)** — the grep upgrade; pairs with fzf/bat, installed on neither Mac yet.
- **pay-respects** — maintained successor to `thefuck`: run it after a botched command to get the corrected one.
- **git-delta** — prettier git diffs/log pager (`brew install git-delta` + two lines of git config).
- **atuin** — searchable, syncable shell history (replaces Ctrl-R search; bigger workflow change).
- **mise** — one version manager for node/python/ruby/etc.; would retire the nvm + brew-ruby + friends sprawl.
- **zoxide `--cmd cd`** — make plain `cd` smart instead of using `z`; one-line change in `.zshrc` if wanted.

## Customization

Fork it and make it yours. Prompt taste lives in `starship.toml`
(or `.p10k.zsh` if you flip the engine); machine quirks live in
`~/.zshrc.local`, never in the tracked files.
