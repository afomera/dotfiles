# dotfiles

Managed with [chezmoi](https://www.chezmoi.io/). Modular zsh config with XDG base directories, starship prompt, and automated setup for a Ruby/Rails + JS/TS development environment on macOS.

## New machine setup

```sh
sh -c "$(curl -fsLS https://raw.githubusercontent.com/afomera/dotfiles/refs/heads/main/install)"
```

This will:
1. Install Xcode CLI tools and Homebrew
2. Install 1Password + CLI
3. Install chezmoi
4. Prompt for config (name, email, machine profile, work org, 1Password SSH)
5. Apply all dotfiles and run setup scripts

## What happens during `chezmoi apply`

**Before scripts** — backup existing dotfiles, install Xcode/Homebrew, install rustup + Node LTS

**File sync** — all configs from `home/` are applied to `~`

**After scripts** — `brew bundle` (installs all packages), VS Code extensions, macOS defaults, direnv allow

## How it works

- `.chezmoiroot` points chezmoi at `home/` as the source directory
- `~/.zshenv` sets `ZDOTDIR=~/.config/zsh` — the only zsh file in `~`
- `~/.config/zsh/.zshrc` auto-discovers and sources files from an allowlist of `~/.config/<tool>/` directories
- Load order: `env.sh` files first (PATH, exports) → `init.zsh` + other files second (eval, aliases)
- `00-xdg/` sorts first, setting XDG vars before anything else needs them

## Managed tool configs

| Directory | What it does |
|-----------|-------------|
| `00-xdg` | XDG base directory variables |
| `direnv` | direnv hook |
| `git` | config, aliases, global ignore, commit template |
| `go` | GOPATH, GOBIN |
| `homebrew` | Brewfile, brew shellenv |
| `node` | fnm init |
| `postgres` | Postgres.app CLI tools on PATH |
| `ruby` | YJIT, gemrc, irbrc, Rails aliases |
| `rubyenv` | RubyEnv.app shims |
| `rust` | cargo env |
| `starship` | prompt config |
| `system` | EDITOR, LANG, general aliases, ~/.local/bin |
| `vscode` | VS Code CLI on PATH |
| `zsh` | history, completion, plugins, functions |

## Adding a new tool

1. Create `home/private_dot_config/<tool>/` with `env.sh` and/or `init.zsh`
2. Add `<tool>` to the allowlist in `home/private_dot_config/zsh/dot_zshrc`
3. `chezmoi apply`

## Day-to-day commands

```sh
chezmoi apply          # Apply changes
chezmoi diff           # Preview what would change
chezmoi edit <file>    # Edit a managed file
chezmoi add <file>     # Start managing a new file
chezmoi cd             # cd into the source directory
```

## Manual installs

These require sudo or App Store sign-in and aren't automated:

```sh
brew install --cask zoom
brew install --cask docker
mas install 441258766  # Magnet
```

Other apps to install manually: Expandly.app, Conductor.build, Codex App
