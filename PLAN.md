# Dotfiles Overhaul Plan

## Context

Starting a new job soon and the current dotfiles are stale — ASDF references everywhere, iTerm2 configs for a terminal no longer used, Laravel aliases, outdated Node/Rust versions, and scattered install scripts. Goal: a clean, fast, single-command setup for a fresh Mac focused on Ruby/Rails + JS/TS development with modern tooling.

**Using chezmoi** for dotfile management with the `.chezmoiroot` pattern (inspired by [aaronmallen/dotfiles](https://github.com/aaronmallen/dotfiles)).

---

## How It Works

- `.chezmoiroot` contains `home` — chezmoi source files live in `home/`, repo-level files (README, install) stay at root
- `install` script at repo root bootstraps everything on a fresh Mac
- `chezmoi apply` copies/templates files from `home/` to `~`
- File naming: `dot_zshrc` → `~/.zshrc`, `private_dot_ssh/` → `~/.ssh/`
- Templates (`.tmpl`): Use `{{ .variable }}` for machine-specific values (work org, email)
- Scripts: `run_once_before_*` runs once before file copy, `run_onchange_*` re-runs when content changes
- New machine setup: clone repo → run `./install`

---

## New Repository Structure

```
dotfiles/
├── .chezmoiroot                         # Contains "home"
├── install                              # Bootstrap script for fresh machines
├── README.md                            # Rewritten docs
│
└── home/                                # chezmoi source directory
    ├── .chezmoi.toml.tmpl               # Config template (prompts for email, work org)
    ├── .chezmoidata/
    │   └── fonts.yml                    # Font list for .chezmoiexternal.toml.tmpl
    ├── .chezmoiexternal.toml.tmpl        # External deps (zsh plugins, fonts)
    ├── .chezmoiscripts/
    │   ├── run_once_before_00-backup.sh          # Backs up existing dotfiles before overwriting
    │   ├── run_once_before_01-xcode-homebrew.sh
    │   ├── run_once_before_02-version-managers.sh
    │   ├── run_onchange_before_03-install-packages.sh.tmpl  # Re-runs when Brewfile changes
    │   ├── run_once_after_04-vscode-extensions.sh
    │   ├── run_once_after_05-macos-defaults.sh
    │   └── run_once_after_06-claude-code.sh
    │
    ├── .chezmoiignore                    # Files chezmoi should not manage
    │
    ├── private_dot_config/
    │   ├── 00-xdg/
    │   │   └── env.sh.tmpl              # XDG base directory vars (sorts first via 00- prefix)
    │   ├── direnv/
    │   │   └── init.zsh                 # eval "$(direnv hook zsh)"
    │   ├── go/
    │   │   └── env.sh                   # GOPATH, GOBIN, PATH
    │   ├── ghostty/
    │   │   └── config                   # Ghostty terminal config
    │   ├── postgres/
    │   │   └── env.sh                   # Postgres.app CLI tools on PATH
    │   ├── rubyenv/
    │   │   └── env.sh                   # RubyEnv.app shims (Ruby + Node)
    │   ├── git/
    │   │   ├── aliases.zsh              # Git aliases (gs, gf, ga, etc.)
    │   │   ├── config.tmpl              # Git config (replaces ~/.gitconfig)
    │   │   ├── commit_template          # Commit template (replaces ~/.gitmessage)
    │   │   └── ignore                   # Global gitignore
    │   ├── homebrew/
    │   │   ├── Brewfile.tmpl            # Templated for profile (personal/work)
    │   │   ├── env.sh                   # Sets HOMEBREW_BUNDLE_FILE + PATH
    │   │   └── init.zsh                 # eval "$(brew shellenv)"
    │   ├── nvim/
    │   │   └── init.vim                 # Minimal neovim config (sensible defaults)
    │   ├── ruby/
    │   │   ├── env.sh                   # RUBY_YJIT_ENABLE, GEMRC, IRBRC, etc.
    │   │   ├── gemrc                    # Gem config (moved from ~/.gemrc)
    │   │   ├── irbrc                    # IRB config (moved from ~/.irbrc)
    │   │   └── init.zsh                 # rv shell init + aliases (b, bi, be, etc.)
    │   ├── rust/
    │   │   └── init.zsh                 # source $HOME/.cargo/env
    │   ├── node/
    │   │   └── init.zsh                 # eval "$(fnm env --use-on-cd)"
    │   ├── starship/
    │   │   ├── config.toml              # Prompt config (migrated from afomera.zsh-theme)
    │   │   ├── env.sh                   # STARSHIP_CONFIG + STARSHIP_CACHE
    │   │   └── init.zsh                 # eval "$(starship init zsh)"
    │   ├── system/
    │   │   ├── aliases.sh               # General aliases (cls, projects, .., etc.)
    │   │   └── env.sh                   # EDITOR, LANG, PATH for ~/.bin
    │   ├── tmux/
    │   │   └── tmux.conf                # Tmux config (moved from ~/.tmux.conf)
    │   └── zsh/
    │       ├── dot_zshrc                # Auto-discovery zshrc (sources all ~/.config/**/*.{sh,zsh})
    │       ├── config.zsh               # Zsh options (history, completion, etc.)
    │       ├── fpath.zsh                # Completions from ~/.local/share/zsh-completions
    │       ├── functions.zsh            # Shell functions (gitwork, etc.)
    │       └── plugins.zsh             # Source zsh-autosuggestions + syntax-highlighting
    │
    ├── dot_zshenv                       # Sets ZDOTDIR=~/.config/zsh (tiny, only file zsh needs in ~)
    ├── dot_hushlogin                    # Suppress login message (keep)
    ├── create_dot_envrc                 # Global ~/.envrc for direnv (created once, never overwritten)
    │
    ├── private_dot_ssh/
    │   ├── config.tmpl                  # SSH config (template for work host)
    │   ├── private_id_ed25519.tmpl      # Private key (pulled from 1Password)
    │   └── id_ed25519.pub.tmpl          # Public key (pulled from 1Password)
    │
    # NOTE: remove_ entries are added in Phase 6 AFTER verifying the new config works.
    # Do NOT create these during initial setup -- see EXECUTION_PLAN.md.
    ├── remove_dot_zshrc                  # Moved to ~/.config/zsh/.zshrc
    ├── remove_dot_gemrc                  # Clean up old symlinks/files
    ├── remove_dot_irbrc
    ├── remove_dot_gitconfig
    ├── remove_dot_gitmessage
    ├── remove_dot_aliases
    ├── remove_dot_aliases.local          # Clean up machine-local aliases file
    ├── remove_dot_env-vars               # Replaced by direnv ~/.envrc
    ├── remove_dot_tool-versions
    ├── remove_dot_railsrc.disabled
    ├── remove_dot_tmux.conf
    ├── remove_dot_vimrc
    ├── remove_dot_vimrc.bundles
    ├── remove_dot_vim                    # Old ~/.vim/ directory
    │
    └── private_dot_bin/
        └── executable_tat              # Tmux session script (keep)
```

**Files to delete from repo (no chezmoi equivalent):**
- `install-dotfiles.rb`, `deprecated-setup.sh`, `dev-ops-setup.sh`
- `dev-start.sh`, `dev-stop.sh`, `install-terminal-tools.sh`, `install-dependencies.sh`
- `.tool-versions`, `tool-versions`
- `iTerm2/` directory

---

## Implementation Steps

### Step 1: Create repo scaffolding

**`.chezmoiroot`** — Single line: `home`

**`install`** — Bootstrap script for fresh machines (structure inspired by [aaronmallen/dotfiles](https://github.com/aaronmallen/dotfiles/blob/main/install)):
```sh
#!/bin/bash
set -e

apply_dotfiles() {
  echo "==> Applying dotfiles"
  chezmoi init afomera --apply
  (cd "$HOME/.local/share/chezmoi" && git remote remove origin 2>/dev/null || true && git remote add origin git@github.com:afomera/dotfiles.git)
}

install_1password() {
  if ! brew list --cask 1password >/dev/null 2>&1; then
    echo "==> Installing 1Password"
    brew install --cask 1password
  fi

  if ! command -v op >/dev/null 2>&1; then
    echo "==> Installing 1Password CLI"
    brew install --cask 1password-cli
    prompt_1password_configuration
  fi
}

prompt_1password_configuration() {
  echo ""
  echo "==> Please complete the following steps:"
  echo "  1. Open 1Password"
  echo "  2. Sign in to 1Password CLI if prompted"
  echo "  3. Go to Settings > Developer"
  echo "  4. Enable 'Connect with 1Password CLI'"
  echo ""
  printf "Press Enter once you have completed these steps..."
  read -r
}

install_chezmoi() {
  if ! command -v chezmoi >/dev/null 2>&1; then
    echo "==> Installing chezmoi"
    brew install chezmoi
  fi
}

install_xcode_cli() {
  if ! xcode-select -p >/dev/null 2>&1; then
    echo "==> Installing Xcode CLI tools"
    xcode-select --install
    printf "Press Enter after Xcode CLI tools installation completes..."
    read -r
  fi
}

install_homebrew() {
  if ! command -v brew >/dev/null 2>&1; then
    echo "==> Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
}

case "$(uname -s)" in
Darwin)
  install_xcode_cli
  install_homebrew
  install_1password
  install_chezmoi
  apply_dotfiles

  echo "Setup Complete"
  echo "Open a new terminal to use your new shell config."
  zsh
  ;;
*)
  echo "Unsupported operating system: $(uname -s)"
  exit 1
  ;;
esac
```

### Step 2: Create `home/.chezmoiignore`

Prevents chezmoi from managing files that shouldn't be synced. Since `.chezmoiroot` is `home`, only entries inside `home/` matter — repo-root files like `README.md` are already outside the source tree. Uses template conditionals to skip 1Password SSH keys when not configured:
```
.DS_Store

{{ if not .use_1password }}
.ssh/id_ed25519
.ssh/id_ed25519.pub
{{ end }}
```

### Step 3: Create `home/.chezmoidata/fonts.yml` and `home/.chezmoiexternal.toml.tmpl`

**`home/.chezmoidata/fonts.yml`** — Font list (add/remove fonts here):
```yaml
fonts:
  nerd_fonts:
    - name: IBMPlexMono
      file: IBMPlexMono.tar.xz
    - name: FiraCode
      file: FiraCode.tar.xz
    - name: JetBrainsMono
      file: JetBrainsMono.tar.xz
    - name: Monaspace
      file: Monaspace.tar.xz
```

**`home/.chezmoiexternal.toml.tmpl`** — External dependencies, cloned/updated automatically (mirroring [aaronmallen's setup](https://github.com/aaronmallen/dotfiles/blob/main/home/.chezmoiexternal.toml.tmpl)):

```toml
[".local/share/zsh-autosuggestions"]
    type = "git-repo"
    url = "https://github.com/zsh-users/zsh-autosuggestions.git"
    refreshPeriod = "168h"
    private = true

[".local/share/zsh-completions"]
    type = "git-repo"
    url = "https://github.com/zsh-users/zsh-completions.git"
    refreshPeriod = "168h"
    private = true

[".local/share/zsh-syntax-highlighting"]
    type = "git-repo"
    url = "https://github.com/zsh-users/zsh-syntax-highlighting.git"
    refreshPeriod = "168h"
    private = true

{{- $fontDir := "" }}
{{- if eq .chezmoi.os "darwin" }}
{{- $fontDir = "Library/Fonts" }}
{{- else if eq .chezmoi.os "linux" }}
{{- $fontDir = ".local/share/fonts" }}
{{- end }}
{{- range .fonts.nerd_fonts }}

["{{ $fontDir }}/{{ .name }}"]
    type = "archive"
    url = {{ gitHubLatestReleaseAssetURL "ryanoasis/nerd-fonts" .file | quote }}
    refreshPeriod = "168h"
    extract = true
{{- end }}
```

Zsh plugins land in `~/.local/share/` and are sourced from `dot_zshrc`. Fonts loop over `.chezmoidata/fonts.yml` so adding a font is just a new YAML entry. `refreshPeriod = "168h"` means `chezmoi apply` auto-updates them weekly.

### Step 4: Create `home/.chezmoi.toml.tmpl`

```toml
{{- $fullName := promptStringOnce . "fullName" "What is your full name?" -}}
{{- $email := promptStringOnce . "email" "What is your email address?" -}}
{{- $profile := promptChoiceOnce . "profile" "Machine profile" (list "personal" "work") -}}
{{- $workOrg := promptStringOnce . "work_org" "Work GitHub org name (or 'none' to skip)" -}}
{{- $use1password := promptBoolOnce . "use_1password" "Use 1Password for SSH keys?" -}}

[data]
    fullName = {{ $fullName | quote }}
    email = {{ $email | quote }}
    profile = {{ $profile | quote }}
    work_org = {{ $workOrg | quote }}
    use_1password = {{ $use1password }}

[git]
    autoCommit = false
    autoPush = false
```

> Note: Enable `autoCommit` and `autoPush` after the migration is stable (Phase 8).

### Step 5: Create `home/private_dot_config/homebrew/`

**`Brewfile.tmpl`** — Templated Brewfile with profile-based conditionals:

**CLI tools (always installed):** `starship`, `neovim`, `tmux`, `tmuxinator`, `gh`, `git-delta`, `bat`, `ripgrep`, `jq`, `direnv`, `ffmpeg`, `imagemagick`, `libvips`, `sqlite`, `go`, `golangci-lint`, `awscli`, `ansible`, `terraform`, `caddy`, `cloudflared`, `ngrok`, `tree`, `fnm`, `rv`, `heroku`

> Note: `chezmoi` is omitted — it's already installed by the `install` script before `brew bundle` runs. `rv` is [rv](https://github.com/spinel-coop/rv), a fast Ruby version manager; after install, use `rv install <version>` to set up a default Ruby.

**Cask apps (always installed):** `ghostty`, `visual-studio-code`, `1password`, `postgres-app`, `tableplus`, `zoom`, `google-chrome`, `magnet`, `raycast`, `docker`, `cleanshot`

**Cask apps (profile-conditional):**
- Work only: `slack`
- Personal only: (add as needed)

Uses `{{ if eq .profile "work" }}` / `{{ if eq .profile "personal" }}` guards, same pattern as Aaron's setup.

> Note: IBM Plex Mono (Nerd Font variant) is installed via `.chezmoiexternal.toml.tmpl` instead of Homebrew.

**Comments for manual installs:** RubyEnv.app, Taddly.app, GitChime.com, Expandly.app, Conductor.build, Codex App, Codex CLI. Claude Code CLI via `curl -fsSL https://claude.ai/install.sh | bash`. Claude Desktop from `https://claude.ai/api/desktop/darwin/universal/dmg/latest/redirect`.

**`env.sh`** — Sourced early in shell init:
```sh
#!/usr/bin/env sh
export HOMEBREW_BUNDLE_FILE="$HOME/.config/homebrew/Brewfile"
export PATH="/opt/homebrew/bin:$PATH"
```

**`init.zsh`** — Sourced from `dot_zshrc`:
```zsh
#!/usr/bin/env zsh
eval "$(brew shellenv)"
```

### Step 6: Create `home/.chezmoiscripts/`

All scripts are idempotent.

**run_once_before_00-backup.sh** — Backs up existing dotfiles before chezmoi overwrites them. Creates `~/.dotfiles-backup-YYYYMMDD/` with copies of `.zshrc`, `.zshenv`, `.gitconfig`, `.gitmessage`, `.tmux.conf`, `.gemrc`, `.irbrc`, `.ssh/config`. Uses `cp -L` to resolve symlinks into real files. Runs once, never again.

**run_once_before_01-xcode-homebrew.sh** — Xcode CLI tools (skip if installed), Homebrew (skip if installed). Lightweight since `install` script handles the initial setup, but needed for `chezmoi init --apply` on subsequent machines.

**run_once_before_02-version-managers.sh** — Install rustup if missing (`-y` for non-interactive). Install latest Node LTS via fnm.

**run_onchange_before_03-install-packages.sh.tmpl** — Named with `before_03` prefix to ensure it runs after `01-xcode-homebrew` installs Homebrew. Uses hash comment so it re-runs whenever Brewfile content changes ([pattern from Aaron's setup](https://github.com/aaronmallen/dotfiles/blob/main/home/.chezmoiscripts/run_onchange_install-packages.sh.tmpl)):

```sh
#!/usr/bin/env sh
set -e

# Brewfile hash: {{ include "private_dot_config/homebrew/Brewfile.tmpl" | sha256sum }}
command -v brew > /dev/null \
  && brew update \
  && brew bundle --file="$HOME/.config/homebrew/Brewfile" \
  && brew upgrade \
  && brew cleanup
```

**run_once_after_04-vscode-extensions.sh** — Detect `code` or `cursor` CLI (skip if neither found). Install: `Shopify.ruby-lsp`, `Shopify.ruby-extensions-pack`, `waderyan.gitblame`, `GitHub.copilot-chat`, `GitHub.github-vscode-theme`, `herbcss.herb-lsp`, `ybaumes.highlight-trailing-white-spaces`, `yagudaev.run-specs`, `marcoroth.stimulus-lsp`, `tomoki1207.pdf`, `CraigMaslowski.erb`

**run_once_after_05-macos-defaults.sh** — Finder defaults, screenshot format, TextEdit plain text.

**run_once_after_06-claude-code.sh** — Install Claude Code CLI via `curl -fsSL https://claude.ai/install.sh | bash` (skip if already installed). Moved to `after` since it's not a dependency for other setup steps.

### Step 7: Create/update config files in `home/`

#### Modular zsh system (replaces oh-my-zsh)

Adopts [Aaron's auto-discovery pattern](https://github.com/aaronmallen/dotfiles/tree/main/home/private_dot_config/private_zsh) with an **allowlist** approach. The `.zshrc` globs all `*.sh` and `*.zsh` files from an explicit list of managed directories under `~/.config/` and sources them in order: `env.sh` first → everything else → `completion.zsh` last. Each tool gets its own directory. To add a new tool: create `~/.config/<tool>/` with `env.sh`/`init.zsh` files AND add the directory name to the allowlist in `dot_zshrc`.

**dot_zshenv** — Tiny file at `~/.zshenv`, the only zsh file in `~`. Also preserves Cargo env for non-interactive shells (scripts, editors, cron) that don't load `.zshrc`:
```zsh
#!/usr/bin/env zsh
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
```

**private_dot_config/zsh/dot_zshrc** — The auto-discovery zshrc (lives at `~/.config/zsh/.zshrc`):
```zsh
#!/usr/bin/env zsh

# Auto-discover config files from ONLY the directories we manage (allowlist).
# This prevents third-party tools (raycast, zed, mise, etc.) from accidentally
# having their .sh/.zsh files sourced as shell config.
typeset -U config_files
config_files=(${HOME}/.config/{00-xdg,direnv,git,go,homebrew,node,postgres,ruby,rubyenv,rust,starship,system,zsh}/**/*.{sh,zsh}(N)~*/zsh/.zshrc)

# Load env.sh files first (00-xdg sorts first, setting XDG_* vars before others need them)
for file in ${(M)config_files:#*/env.sh}; do source $file; done

# Load everything except env.sh and completion.zsh
for file in ${${config_files:#*/env.sh}:#*/completion.zsh}; do source $file; done

# Add completion dirs to fpath, then init compinit
for file in ${(M)config_files:#*/completion.zsh}; do fpath=(${file:h} $fpath); done
autoload -Uz compinit
compinit

# Source completions after compinit
for file in ${(M)config_files:#*/completion.zsh}; do source $file; done

unset config_files
```

> Note: No inline `brew shellenv` needed — `homebrew/env.sh` adds `/opt/homebrew/bin` to PATH during the env.sh phase, and `homebrew/init.zsh` runs `eval "$(brew shellenv)"` in the second pass. The `00-xdg` prefix ensures XDG vars are set before any `env.sh` that references them (like `ruby/env.sh`).

**private_dot_config/zsh/config.zsh** — Zsh options:
- History: `SHARE_HISTORY`, `EXTENDED_HISTORY`, `HIST_IGNORE_ALL_DUPS`, `HIST_REDUCE_BLANKS`
- Completion: `COMPLETE_IN_WORD`, `complete_aliases`
- Misc: `LOCAL_OPTIONS`, `LOCAL_TRAPS`, `NO_LIST_BEEP`

**private_dot_config/zsh/plugins.zsh** — Sources zsh plugins from `~/.local/share/` (guarded):
- `zsh-autosuggestions` and `zsh-syntax-highlighting` (managed by `.chezmoiexternal.toml.tmpl`)

**private_dot_config/zsh/fpath.zsh** — Adds `~/.local/share/zsh-completions/src` to `fpath`, plus each `~/.config/*` topic folder

**private_dot_config/zsh/functions.zsh** — Shell functions:
- `gitwork()` (moved from zshrc; note: depends on `ruby` being installed)

#### Starship prompt (replaces afomera.zsh-theme)

**private_dot_config/starship/config.toml** — Migrated from `afomera.zsh-theme`:

Original prompt: `username (green/red) in directory (bold green) on branch (red) !/?` → newline → `± or ○`

Starship equivalent:
```toml
format = """
$username\
$hostname\
 in \
$directory\
$git_branch\
$git_status\
$line_break\
$character"""

right_format = "$ruby$nodejs$golang"

[username]
show_always = true
style_user = "green"
format = "[$user]($style)"

[directory]
style = "bold green"
truncation_length = 0

[git_branch]
format = " on [$branch]($style)"
style = "red"

[git_status]
format = "[$modified$untracked]($style)"
style = "green"
modified = "!"
untracked = "?"

[character]
success_symbol = "[±](bold)"
error_symbol = "[±](bold red)"

[hostname]
ssh_only = true
format = "[@$hostname]($style)"
style = "yellow"

[ruby]
format = "[$symbol$version]($style) "
style = "red"
symbol = "rb "

[nodejs]
format = "[$symbol$version]($style) "
style = "green"
symbol = "node "

[golang]
format = "[$symbol$version]($style) "
style = "cyan"
symbol = "go "
```

**private_dot_config/starship/env.sh**:
```sh
#!/usr/bin/env sh
export STARSHIP_CONFIG="$HOME/.config/starship/config.toml"
export STARSHIP_CACHE="$HOME/.cache/starship"
```

**private_dot_config/starship/init.zsh**:
```zsh
#!/usr/bin/env zsh
eval "$(starship init zsh)"
```

#### XDG base directories

**private_dot_config/00-xdg/env.sh.tmpl** — Sets XDG vars so tools use `~/.config/`, `~/.local/share/`, etc. instead of cluttering `~`. Template with macOS/Linux branches (macOS maps `XDG_CACHE_HOME` → `~/Library/Caches`, etc.). Named `00-xdg` so it sorts **first** alphabetically among env.sh files — this is critical because `ruby/env.sh`, `starship/env.sh`, and others reference `$XDG_CONFIG_HOME` and `$XDG_CACHE_HOME`. Only defines the vars your config actually uses:
- `XDG_CONFIG_HOME`, `XDG_CACHE_HOME`, `XDG_DATA_HOME`, `XDG_STATE_HOME`, `XDG_BIN_HOME`

#### Tool init files (each auto-discovered by dot_zshrc)

**private_dot_config/homebrew/env.sh** — `HOMEBREW_BUNDLE_FILE` + PATH
**private_dot_config/homebrew/init.zsh** — `eval "$(brew shellenv)"`

**private_dot_config/ruby/env.sh** — Points Ruby tools at XDG paths + enables YJIT:
```sh
#!/usr/bin/env sh
export RUBY_YJIT_ENABLE=1
export GEMRC="$XDG_CONFIG_HOME/ruby/gemrc"
export IRBRC="$XDG_CONFIG_HOME/ruby/irbrc"
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/ruby/bundle"
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME/ruby/bundle"
export GEM_SPEC_CACHE="$XDG_CACHE_HOME/ruby/gem"
```

**private_dot_config/ruby/gemrc** (moved from `~/.gemrc`):
```yaml
---
gem: --no-document
:sources:
- https://rubygems.org
```

**private_dot_config/ruby/irbrc** (moved from `~/.irbrc`, replaces commented-out version):
```ruby
IRB.conf[:SAVE_HISTORY] = 10000
IRB.conf[:HISTORY_FILE] = "#{ENV['XDG_STATE_HOME']}/.irb_history"
IRB.conf[:USE_AUTOCOMPLETE] = true
```

**private_dot_config/ruby/init.zsh** — `command -v rv &>/dev/null && eval "$(rv shell init zsh)"` + Ruby/Rails aliases (`b`, `bi`, `be`, `fs`, `dropdb`)

**private_dot_config/go/env.sh** — Go paths:
```sh
#!/usr/bin/env sh
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"
```

**private_dot_config/node/init.zsh** — `command -v fnm &>/dev/null && eval "$(fnm env --use-on-cd)"`

**private_dot_config/rust/init.zsh** — `[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"`

**private_dot_config/postgres/env.sh** — Postgres.app CLI tools:
```sh
#!/usr/bin/env sh
export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"
```

**private_dot_config/rubyenv/env.sh** — RubyEnv.app shims (Ruby + Node):
```sh
#!/usr/bin/env sh
export PATH="$HOME/.rubyenv/shims:$HOME/.rubyenv/node/shims:$PATH"
```

**private_dot_config/system/env.sh** — General environment:
```sh
#!/usr/bin/env sh
export EDITOR=nvim
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PATH="$HOME/.bin:$PATH"
```

**private_dot_config/system/aliases.sh** — General aliases:
```sh
#!/usr/bin/env sh
alias cls=clear
alias vim=nvim
alias ..="cd .."
alias ...="cd ../.."
alias projects="cd ~/Projects"
```

**private_dot_config/direnv/init.zsh** — `command -v direnv &>/dev/null && eval "$(direnv hook zsh)"`

**private_dot_config/git/aliases.zsh** — Git aliases (`gs`, `gf`, `ga`, `ga.`, `gc`, `gitclean`)

#### Git config (moved under `~/.config/git/` — Git natively supports this XDG path)

**private_dot_config/git/config.tmpl** (replaces `~/.gitconfig`):
```
[color]
    ui = true

[core]
    editor = nvim
    excludesfile = ~/.config/git/ignore
    pager = delta

[commit]
    template = ~/.config/git/commit_template

[delta]
    dark = true
    line-numbers = true
    navigate = true

[init]
    defaultBranch = main

[interactive]
    diffFilter = delta --color-only

[merge]
    conflictstyle = zdiff3

[pager]
    branch = false
    tag = false

[pull]
    rebase = false

[push]
    autoSetupRemote = true

[rebase]
    autosquash = true

[user]
    name = {{ .fullName }}
    email = {{ .email }}

{{ if ne .work_org "none" -}}
[url "git@work-github:{{ .work_org }}/"]
    insteadOf = work:
{{ end -}}
```

**private_dot_config/git/commit_template** (moved from `~/.gitmessage`, content kept):
- Structured format: `[commit_type] [summary]` → Because → This commit

**private_dot_config/git/ignore** (new — global gitignore, merges existing `~/.config/git/ignore` content):
```
.DS_Store
.idea
*.iml
.vscode
*.code-workspace
*.log
**/.claude/settings.local.json
Session.vim
sftp-config.json
```

**private_dot_ssh/config.tmpl** (from `.ssh/config`, now a template):
- Replace insecure `StrictHostKeyChecking no` with `AddKeysToAgent yes`, `IdentityFile ~/.ssh/id_ed25519`
- Guard macOS-only directive: `{{ if eq .chezmoi.os "darwin" }}UseKeychain yes{{ end }}`
- Conditional work-github host alias using `{{ if ne .work_org "none" }}` with `IdentitiesOnly yes` to prevent key leaking across hosts

**private_dot_ssh/private_id_ed25519.tmpl** (new, pulled from 1Password, guarded):
- Guarded by `{{ if .use_1password }}` — skipped entirely if user answers "no" during `chezmoi init`
- Uses `{{ onepasswordRead "op://Personal/SSH Key/private key" }}` (adjust vault/item path to match your 1Password setup)
- chezmoi's `private_` prefix ensures `0600` permissions
- Add to `.chezmoiignore`: `{{ if not .use_1password }}private_dot_ssh/private_id_ed25519{{ end }}`

**private_dot_ssh/id_ed25519.pub.tmpl** (new, pulled from 1Password, guarded):
- Same guard: `{{ if .use_1password }}`
- Uses `{{ onepasswordRead "op://Personal/SSH Key/public key" }}`
- Add to `.chezmoiignore`: `{{ if not .use_1password }}private_dot_ssh/id_ed25519.pub{{ end }}`

**private_dot_config/tmux/tmux.conf** — Minimal config for occasional use:
```conf
# True color support
set -g default-terminal 'tmux-256color'
set -as terminal-overrides ',xterm*:Tc'

# Mouse support
set -g mouse on

# Splits open in current directory
bind '\' split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"

# Window numbering from 1
set -g base-index 1
set-window-option -g pane-base-index 1
set -g renumber-windows on

# Scrollback
set -g history-limit 50000

# No delay on Esc
set -sg escape-time 10

# Reload config
bind r source-file ~/.config/tmux/tmux.conf \; display "tmux config reloaded."
```

**private_dot_config/nvim/init.vim** — Minimal config for occasional use (no plugin manager, no vim-plug):
```vim
set nocompatible
let mapleader = " "

syntax enable
set mouse=a
set clipboard+=unnamedplus
set number
set numberwidth=3
set ruler
set autoread

" Search
set hlsearch
set incsearch
nnoremap <CR> :nohlsearch<CR><CR>

" Splits
set splitbelow
set splitright
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Indentation
set autoindent
set shiftwidth=2
set smarttab
set expandtab
set scrolloff=5

" Misc
set nobackup
set nowritebackup
set noswapfile
set noerrorbells
set novisualbell
```

**create_dot_envrc** (new, replaces `env-vars`):
- Uses `create_` prefix so chezmoi seeds it on first apply but never overwrites local edits
- Ships with a comment header explaining its purpose (global env vars via direnv)
- Empty by default — add secrets locally per machine, they stay untracked
- Requires `direnv allow ~` after first creation

**private_dot_config/ghostty/config** (new):
```
font-family = "BlexMono Nerd Font"
font-size = 14
theme = GitHub Dark
window-padding-x = 8
window-padding-y = 8
shell-integration = zsh
cursor-style = bar
cursor-style-blink = false
mouse-hide-while-typing = true
copy-on-select = clipboard
keybind = shift+enter=text:\n
```

### Step 8: Rename remaining files into `home/` (content unchanged)

- `gemrc` → `home/private_dot_config/ruby/gemrc` (updated with `:sources` config)
- `irbrc` → `home/private_dot_config/ruby/irbrc` (rewritten — history, autocomplete)
- `gitmessage` → `home/private_dot_config/git/commit_template`
- `gitconfig` → `home/private_dot_config/git/config.tmpl` (expanded with delta, global ignore, etc.)
- `hushlogin` → `home/dot_hushlogin`
- `.config/nvim/init.vim` → `home/private_dot_config/nvim/init.vim` (rewritten as minimal config)
- `tmux.conf` → `home/private_dot_config/tmux/tmux.conf`
- `bin/tat` → `home/private_dot_bin/executable_tat`

### Step 9: Clean up existing symlinks

> **Important migration note:** The current `install-dotfiles.rb` created symlinks from `~` into the repo (e.g. `~/.tmux.conf` → `~/Projects/dotfiles/tmux.conf`). Build the entire `home/` structure first, then run `chezmoi init --apply` — chezmoi will replace each symlink with a real managed file. Only delete old repo files *after* chezmoi has applied successfully. If you delete repo files first, the symlinks break and your configs disappear.

All stale symlinks and old files are handled automatically by `remove_` entries in the chezmoi source (e.g. `remove_dot_gemrc` deletes `~/.gemrc`, `remove_dot_tmux.conf` deletes `~/.tmux.conf`). No manual cleanup needed.

### Step 10: Delete obsolete files from repo

- `install-dotfiles.rb`
- `deprecated-setup.sh`, `dev-ops-setup.sh`, `dev-start.sh`, `dev-stop.sh`
- `install-terminal-tools.sh`, `install-dependencies.sh`
- `env-vars` (replaced by direnv `~/.envrc`)
- `aliases` (split into `private_dot_config/git/aliases.zsh` + `private_dot_config/ruby/init.zsh`)
- `railsrc` (commented out on current system, not needed)
- `aliases.local` (no longer needed — use per-tool config files instead)
- `oh-my-zsh/` directory (replaced by modular zsh system + starship)
- `vimrc`, `vimrc.bundles`, `vim/` directory (replaced by minimal `nvim/init.vim`)
- `.tool-versions`, `tool-versions`
- `iTerm2/` directory
- Original un-renamed config files (after moving to `home/`)

### Step 11: Rewrite `README.md`

Quick start: `./install` (or clone + run). What happens during setup. Day-to-day chezmoi commands. Manual install apps list. Work GitHub account setup instructions.

---

## Verification

1. `chezmoi doctor` — check chezmoi health
2. `chezmoi data` — verify template variables (fullName, email, profile, work_org)
3. `chezmoi apply --dry-run --verbose` — preview all changes
4. `chezmoi apply --verbose` — apply and verify files land correctly
5. Run `chezmoi apply` again — should be a no-op (idempotency)
6. Open a new shell — verify starship prompt loads, no errors
7. Verify auto-discovery: `ls ~/.config/*/env.sh ~/.config/*/init.zsh` — all tool configs present
8. Verify old files removed: `ls ~/.gemrc ~/.gitconfig ~/.tmux.conf ~/.vimrc 2>&1` — should all be "No such file"
9. Verify delta: `git diff` in any repo — should show syntax-highlighted output
10. Spot-check tools: `rv --version`, `fnm --version`, `gh --version`, `bat --version`, `starship --version`, `delta --version`
11. Verify `~/.config/` permissions: `stat -f '%A' ~/.config` — should be `700`
