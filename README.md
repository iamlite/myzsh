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
| zoxide | `cd` directory jumping | Initialized with `--cmd cd`: plain `cd` is the smart jump now (no separate `z`). Replaced `jump` years ago. |
| fzf + fd | Ctrl-T / Alt-C (+ Ctrl-R if atuin is absent) | fd becomes fzf's backend when present (fast, respects `.gitignore`). |
| ripgrep (`rg`) | searching file contents | No shell hook — just installed alongside; pairs with fzf/bat. |
| atuin | Ctrl-R / up-arrow history search | Initialized after fzf, so it **takes over Ctrl-R** (and up-arrow) from fzf when installed. Searchable, syncable history. |
| pay-respects | type `fuck` after a botched command | Maintained successor to `thefuck`. Bound via `pay-respects zsh --alias fuck` — same workflow as the old days. Press-F correction suggestions. Not in homebrew-core; setup installs it from the author's tap (macOS) or install script (Linux). |
| git-delta | git pager | `setup.zsh` sets `core.pager=delta` (+ `interactive.diffFilter`, dark, line-numbers) — only if no pager is configured yet, and only after backing up `~/.gitconfig`. |
| mise | version manager (node/python/ruby/go…) | Activated after the nvm block, so mise wins where installed; nvm remains the fallback. Pin a machine's default node with `mise use -g node@<version>` — per-machine, lives in `~/.config/mise/config.toml`, not in this repo. |
| nvm | node versions (fallback) | Loaded from `~/.nvm`, else from Homebrew's opt dir — probed by path, never via `$(brew --prefix …)`. |
| fast-syntax-highlighting | syntax highlighting plugin | Replaces `zsh-syntax-highlighting` (mutually exclusive — only FSH is enabled/cloned). |
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
Powerlevel10k, the fast-syntax-highlighting/autosuggestions plugins, the
CLI tools above, Starship, and the fonts. If git has no pager configured
yet, it also points git at delta (backing up `~/.gitconfig` first). It does
**not** install Homebrew or nvm for you (it prints the one-liners if
they're missing).

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

## What changed in the rollout (Nov 2026)

The "recommendations" list from the first modernization pass got folded in —
everything above is installed by `setup.zsh` and integrated in `.zshrc`:
ripgrep, pay-respects (bound to `fuck`), git-delta as git's pager, atuin on
Ctrl-R, mise as the primary version manager (nvm kept as fallback), zoxide
behind plain `cd`, and fast-syntax-highlighting in place of
zsh-syntax-highlighting. Then the whole setup was deployed machine by machine
(Air first as the test run, then the Studio and the Linux boxes).

## Customization

Fork it and make it yours. Prompt taste lives in `starship.toml`
(or `.p10k.zsh` if you flip the engine); machine quirks live in
`~/.zshrc.local`, never in the tracked files.
