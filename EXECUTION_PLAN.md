# Execution Plan: Dotfiles Overhaul

> Safe migration order for an existing, in-use Mac. Each phase has a **gate check** -- don't proceed until it passes.

---

## Issues Found in PLAN.md

All issues below have been **fixed in PLAN.md**. This section is kept as a reference for what was changed and why.

### CRITICAL (all fixed)

| # | Issue | Status |
|---|-------|--------|
| C1 | **XDG load order was backwards** -- `xdg/env.sh` sorted LAST (`x` after `g,h,p,r,s`), but `ruby/env.sh` references `$XDG_CONFIG_HOME`. | FIXED: Renamed to `00-xdg/` |
| C2 | **`remove_dot_zshrc` could nuke shell** -- If apply interrupted after remove but before new files land. | FIXED: `remove_` entries deferred to Phase 6 (noted in PLAN.md) |
| C3 | **`.zshenv` overwrote Cargo init** -- Non-interactive shells lost Cargo binaries. | FIXED: `dot_zshenv` now includes `[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"` |
| C4 | **1Password SSH templates failed fatally** -- `onepasswordRead` errors abort entire apply. | FIXED: Added `use_1password` prompt + `.chezmoiignore` conditional |

### HIGH (all fixed)

| # | Issue | Status |
|---|-------|--------|
| H1 | **Double `brew shellenv`** -- ran twice per shell startup, PATH added 3x. | FIXED: Removed inline brew init from `dot_zshrc`; `homebrew/env.sh` + `homebrew/init.zsh` handle it |
| H2 | **Auto-discovery glob was a denylist** -- any future tool `.sh`/`.zsh` in `~/.config/` got auto-sourced. | FIXED: Switched to allowlist of managed directories |
| H3 | **`~/.config/git/ignore` content lost** -- existing `**/.claude/settings.local.json` would be overwritten. | FIXED: Merged into planned `ignore` file |
| H4 | **`~/.ssh/config` clobbered with no backup** -- manual SSH host entries destroyed. | FIXED: Added `run_once_before_00-backup.sh` script |
| H5 | **`autoCommit = true` + `autoPush = true`** during dev. | FIXED: Defaults to `false`, enable in Phase 8 |
| H6 | **`brew upgrade` in onchange script** -- Brewfile edit triggers full system upgrade. | KEPT: User prefers `brew upgrade` to run |

### MEDIUM (all fixed)

| # | Issue | Status |
|---|-------|--------|
| M1 | `rv` path hardcoded to `/opt/homebrew/bin/rv` | FIXED: Uses `$(rv shell init zsh)` via PATH |
| M2 | `GOPATH` changes from `~/gopath` to `~/go` | KEPT: Using `~/go` (Go standard). Old `~/gopath` is stale. |
| M3 | Missing `remove_` for `~/.aliases.local`, `~/.env-vars` | FIXED: Added to `remove_` list in PLAN.md |
| M4 | `install` script used `exec zsh` -- broken config = lost shell | FIXED: Changed to `zsh` without `exec` |
| M5 | `~/.config/` changes from `755` to `700` via `private_` prefix | KEPT: User chose `700` (more secure) |
| M6 | Starship always shows `±` instead of `±` in git / `○` outside | ACCEPTED: Simplification is fine |

---

## Execution Phases

### Phase 0: Safety Net (before touching anything)

**Goal:** Create recovery points so a bad apply can't brick your shell.

- [ ] **0.1** Commit current `overhaul` branch state
- [ ] **0.2** Back up critical dotfiles from `~`:
  ```sh
  mkdir -p ~/dotfiles-backup
  cp -L ~/.zshrc ~/dotfiles-backup/
  cp -L ~/.zshenv ~/dotfiles-backup/ 2>/dev/null
  cp -L ~/.gitconfig ~/dotfiles-backup/ 2>/dev/null
  cp -L ~/.ssh/config ~/dotfiles-backup/ 2>/dev/null
  cp -L ~/.tmux.conf ~/dotfiles-backup/ 2>/dev/null
  cp -L ~/.gemrc ~/dotfiles-backup/ 2>/dev/null
  ```
  (These are the _resolved_ files, not symlinks, so you have real content.)
- [ ] **0.3** Note your current shell works: `echo $SHELL && ruby --version && git --version && cargo --version`
- [ ] **0.4** Make sure you can open a bash shell as fallback: `bash --version`

**Gate:** `~/dotfiles-backup/` exists with readable copies of all configs. You can `source ~/dotfiles-backup/.zshrc` to recover if needed.

---

### Phase 1: Repo Scaffolding (no files applied to ~ yet)

**Goal:** Set up chezmoi structure in the repo. Nothing touches your home directory.

- [ ] **1.1** Create `.chezmoiroot` containing `home`
- [ ] **1.2** Create `home/` directory
- [ ] **1.3** Create `home/.chezmoiignore`
- [ ] **1.4** Create `home/.chezmoi.toml.tmpl`
  - `autoCommit = false`, `autoPush = false` (enable in Phase 8)
  - Includes `use_1password` boolean prompt for SSH key guard
- [ ] **1.5** Create `home/.chezmoidata/fonts.yml`
- [ ] **1.6** Create `home/.chezmoiexternal.toml.tmpl` (zsh plugins + fonts)
- [ ] **1.7** Create `install` script at repo root (use `zsh` not `exec zsh` at the end)

**Gate:** `ls home/.chezmoiroot` -- nope, `cat .chezmoiroot` returns `home`. Repo structure looks right. No chezmoi commands run yet.

---

### Phase 2: Config Files (still repo-only, not applied)

**Goal:** Create all managed config files inside `home/`. Order doesn't matter here since nothing is applied yet. But group by dependency for sanity.

#### 2A: Shell foundation (must be correct -- this is your shell)

- [ ] **2A.1** `home/dot_zshenv` -- Sets ZDOTDIR + preserves Cargo env for non-interactive shells:
  ```zsh
  export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
  [[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
  ```
- [ ] **2A.2** `home/private_dot_config/00-xdg/env.sh.tmpl` -- XDG vars (`00-` prefix = loads first)
- [ ] **2A.3** `home/private_dot_config/zsh/dot_zshrc` -- Auto-discovery zshrc (allowlist glob):
    ```zsh
    config_files=(${HOME}/.config/{00-xdg,direnv,git,go,homebrew,node,postgres,ruby,rubyenv,rust,starship,system,zsh}/**/*.{sh,zsh}(N)~*/zsh/.zshrc)
    ```
  No inline `brew shellenv` -- handled by `homebrew/env.sh` + `homebrew/init.zsh`.
- [ ] **2A.4** `home/private_dot_config/zsh/config.zsh` -- Zsh options (history, completion)
- [ ] **2A.5** `home/private_dot_config/zsh/plugins.zsh` -- Source zsh-autosuggestions + syntax-highlighting
- [ ] **2A.6** `home/private_dot_config/zsh/fpath.zsh` -- Completions fpath setup
- [ ] **2A.7** `home/private_dot_config/zsh/functions.zsh` -- Shell functions (gitwork, etc.)

#### 2B: Homebrew + tool init files

- [ ] **2B.1** `home/private_dot_config/homebrew/Brewfile.tmpl` -- Templated Brewfile
- [ ] **2B.2** `home/private_dot_config/homebrew/env.sh` -- HOMEBREW_BUNDLE_FILE + PATH
- [ ] **2B.3** `home/private_dot_config/homebrew/init.zsh` -- `eval "$(brew shellenv)"`
- [ ] **2B.4** `home/private_dot_config/starship/config.toml` -- Prompt config
- [ ] **2B.5** `home/private_dot_config/starship/env.sh` -- STARSHIP_CONFIG + STARSHIP_CACHE
- [ ] **2B.6** `home/private_dot_config/starship/init.zsh` -- `eval "$(starship init zsh)"`
- [ ] **2B.7** `home/private_dot_config/ruby/env.sh` -- YJIT, GEMRC, IRBRC (now uses $XDG_CONFIG_HOME correctly since 00-xdg loads first)
- [ ] **2B.8** `home/private_dot_config/ruby/gemrc`
- [ ] **2B.9** `home/private_dot_config/ruby/irbrc`
- [ ] **2B.10** `home/private_dot_config/ruby/init.zsh` -- rv init via PATH + aliases
- [ ] **2B.11** `home/private_dot_config/go/env.sh` -- GOPATH, GOBIN
- [ ] **2B.12** `home/private_dot_config/node/init.zsh` -- fnm init
- [ ] **2B.13** `home/private_dot_config/rust/init.zsh` -- source cargo env
- [ ] **2B.14** `home/private_dot_config/postgres/env.sh` -- Postgres.app PATH
- [ ] **2B.15** `home/private_dot_config/rubyenv/env.sh` -- RubyEnv.app shims
- [ ] **2B.16** `home/private_dot_config/direnv/init.zsh` -- direnv hook
- [ ] **2B.17** `home/private_dot_config/system/env.sh` -- EDITOR, LANG, PATH
- [ ] **2B.18** `home/private_dot_config/system/aliases.sh` -- General aliases

#### 2C: Git config

- [ ] **2C.1** `home/private_dot_config/git/config.tmpl` -- Full git config
- [ ] **2C.2** `home/private_dot_config/git/commit_template` -- Moved from ~/.gitmessage
- [ ] **2C.3** `home/private_dot_config/git/ignore` -- Global gitignore (includes existing `**/.claude/settings.local.json`)
- [ ] **2C.4** `home/private_dot_config/git/aliases.zsh` -- Git aliases

#### 2D: Other configs

- [ ] **2D.1** `home/private_dot_config/tmux/tmux.conf`
- [ ] **2D.2** `home/private_dot_config/nvim/init.vim` -- Minimal neovim config
- [ ] **2D.3** `home/private_dot_config/ghostty/config` -- Ghostty terminal config
- [ ] **2D.4** `home/dot_hushlogin`
- [ ] **2D.5** `home/create_dot_envrc` -- Global direnv envrc (created once)
- [ ] **2D.6** `home/private_dot_bin/executable_tat` -- Tmux session script

#### 2E: SSH (key files conditionally skipped via `.chezmoiignore` when `use_1password = false`)

- [ ] **2E.1** `home/private_dot_ssh/config.tmpl` -- SSH config (always applied; work-github host guarded by `work_org`)
- [ ] **2E.2** `home/private_dot_ssh/private_id_ed25519.tmpl` -- Private key (skipped if `use_1password = false`)
- [ ] **2E.3** `home/private_dot_ssh/id_ed25519.pub.tmpl` -- Public key (skipped if `use_1password = false`)

#### 2F: Chezmoi scripts

- [ ] **2F.1** `home/.chezmoiscripts/run_once_before_00-backup.sh` -- Backs up existing configs before overwrite:
  ```sh
  #!/usr/bin/env sh
  set -e
  BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d)"
  mkdir -p "$BACKUP_DIR"
  for f in .zshrc .zshenv .gitconfig .gitmessage .tmux.conf .gemrc .irbrc .ssh/config; do
    [ -e "$HOME/$f" ] && cp -L "$HOME/$f" "$BACKUP_DIR/$f" 2>/dev/null || true
  done
  echo "Backed up existing dotfiles to $BACKUP_DIR"
  ```
- [ ] **2F.2** `home/.chezmoiscripts/run_once_before_01-xcode-homebrew.sh`
- [ ] **2F.3** `home/.chezmoiscripts/run_once_before_02-version-managers.sh`
- [ ] **2F.4** `home/.chezmoiscripts/run_onchange_before_03-install-packages.sh.tmpl` -- Re-runs when Brewfile changes
- [ ] **2F.5** `home/.chezmoiscripts/run_once_after_04-vscode-extensions.sh`
- [ ] **2F.6** `home/.chezmoiscripts/run_once_after_05-macos-defaults.sh`
- [ ] **2F.7** `home/.chezmoiscripts/run_once_after_06-claude-code.sh`

**Gate:** All files exist in `home/`. Run `find home -type f | wc -l` to sanity check count. No `remove_*` files yet. No chezmoi apply yet.

---

### Phase 3: Dry Run (read-only verification)

**Goal:** See exactly what chezmoi WOULD do without touching anything.

- [ ] **3.1** Install chezmoi if needed: `brew install chezmoi`
- [ ] **3.2** Point chezmoi at the local repo: `chezmoi init --source=/Users/afomera/Projects/dotfiles`
  - This prompts for template variables (fullName, email, profile, work_org, use_1password)
  - Answer the prompts carefully -- these feed every template
- [ ] **3.3** Verify template data: `chezmoi data` -- check all values are correct
- [ ] **3.4** Dry run: `chezmoi apply --dry-run --verbose 2>&1 | tee /tmp/chezmoi-dryrun.log`
- [ ] **3.5** Review the dry run output for:
  - Are all expected files listed?
  - Are any UNEXPECTED files being modified?
  - Do template expansions look correct (especially git config, SSH config)?
  - Are any errors or warnings shown?
  - Confirm NO `remove_` actions in this phase

**Gate:** Dry run shows only file creates/updates, no errors, no removes. Template variables expanded correctly. You've read every line of the dry run output.

---

### Phase 4: First Apply (new files land alongside old ones)

**Goal:** Apply chezmoi for real. Old configs still work since we haven't removed them yet.

- [ ] **4.1** `chezmoi apply --verbose`
- [ ] **4.2** Verify new files landed:
  ```sh
  ls ~/.config/zsh/.zshrc
  ls ~/.config/starship/config.toml
  ls ~/.config/homebrew/Brewfile
  ls ~/.config/git/config
  ls ~/.zshenv
  ```
- [ ] **4.3** Test the new shell config WITHOUT replacing your current shell:
  ```sh
  ZDOTDIR=~/.config/zsh zsh -i -c 'echo "New shell works. PATH=$PATH"'
  ```
  Verify: no errors, PATH includes `/opt/homebrew/bin`, tools are findable
- [ ] **4.4** Test more thoroughly in a subshell:
  ```sh
  ZDOTDIR=~/.config/zsh zsh -i
  # In the subshell, verify:
  which ruby && ruby --version
  which git && git --version
  which starship && starship --version
  echo $XDG_CONFIG_HOME  # Should be ~/.config or ~/Library/...
  echo $GEMRC             # Should NOT be empty or start with /
  exit
  ```
- [ ] **4.5** Verify git config works: `git -c include.path=~/.config/git/config config --list`
- [ ] **4.6** Check `chezmoi doctor` for any warnings

**Gate:** New shell config works in a subshell. All tools are findable. XDG vars are set. No empty variable expansions. Old shell still works as primary.

---

### Phase 5: Switch Over (make new config primary)

**Goal:** Start using the new config as your daily driver. Old files still exist as fallback.

- [ ] **5.1** Open a NEW terminal window/tab (don't close the old one!)
- [ ] **5.2** In the new terminal, verify:
  - Starship prompt appears correctly
  - `ruby --version`, `node --version`, `go version` all work
  - `git status` works (git config found)
  - `cargo --version` works
  - Tab completion works
  - Zsh autosuggestions appear
  - Syntax highlighting works
- [ ] **5.3** Keep the old terminal open as escape hatch
- [ ] **5.4** Use the new config for at least a few hours of real work

**Gate:** You've used the new config for real work with no issues. Old terminal is still open as backup.

---

### Phase 6: Clean Up Old Files (add `remove_` entries)

**Goal:** Now that the new config is proven, remove old dotfiles from `~`.

- [ ] **6.1** Create `remove_` entries in `home/`:
  ```
  remove_dot_zshrc
  remove_dot_gemrc
  remove_dot_irbrc
  remove_dot_gitconfig
  remove_dot_gitmessage
  remove_dot_aliases
  remove_dot_aliases.local
  remove_dot_env-vars
  remove_dot_tool-versions
  remove_dot_railsrc.disabled
  remove_dot_tmux.conf
  remove_dot_vimrc
  remove_dot_vimrc.bundles
  remove_dot_vim
  ```
- [ ] **6.2** `chezmoi apply --dry-run --verbose` -- verify only removes, no unexpected changes
- [ ] **6.3** `chezmoi apply --verbose`
- [ ] **6.4** Open a new terminal -- verify everything still works
- [ ] **6.5** `ls ~/.gemrc ~/.gitconfig ~/.tmux.conf ~/.vimrc 2>&1` -- all should be "No such file"

**Gate:** Old dotfiles removed. New terminal works. Git works. No errors on shell startup.

---

### Phase 7: Delete Obsolete Repo Files

**Goal:** Clean up the repo now that everything lives in `home/`.

- [ ] **7.1** Delete from repo (git rm):
  - `install-dotfiles.rb`
  - `deprecated-setup.sh`, `dev-ops-setup.sh`, `dev-start.sh`, `dev-stop.sh`
  - `install-terminal-tools.sh`, `install-dependencies.sh`
  - `env-vars`, `aliases`, `aliases.local`, `railsrc`
  - `oh-my-zsh/` directory
  - `vimrc`, `vimrc.bundles`, `vim/` directory
  - `.tool-versions`, `tool-versions`
  - `iTerm2/` directory
  - Original config files now in `home/`: `gemrc`, `irbrc`, `gitconfig`, `gitmessage`, `tmux.conf`, `hushlogin`, `zshrc`
- [ ] **7.2** Keep `PLAN.md` and `EXECUTION_PLAN.md` for reference (in `.chezmoiignore`)
- [ ] **7.3** Commit everything
- [ ] **7.4** Final `chezmoi apply` -- should be a no-op

**Gate:** `chezmoi apply` is idempotent. Repo is clean. `git status` shows only expected changes.

---

### Phase 8: Finalize

- [ ] **8.1** Enable `autoCommit = true` and `autoPush = true` in `~/.config/chezmoi/chezmoi.toml` (fix H5)
- [ ] **8.2** Rewrite `README.md`
- [ ] **8.3** Test `install` script logic (read-through, don't run on this machine)
- [ ] **8.4** Delete `~/dotfiles-backup/` once confident
- [ ] **8.5** Optionally remove `~/.oh-my-zsh/` directory from home (fix M3)

---

## Emergency Recovery

If at any point your shell breaks:

1. **Open a terminal, it drops to bare zsh:**
   ```sh
   source ~/dotfiles-backup/.zshrc
   ```

2. **Can't even get zsh to start:**
   ```sh
   # Open Terminal.app, change shell to bash in preferences, then:
   bash
   cp ~/dotfiles-backup/.zshrc ~/.zshrc
   cp ~/dotfiles-backup/.zshenv ~/.zshenv 2>/dev/null
   ```

3. **chezmoi apply broke things:**
   ```sh
   chezmoi apply --exclude=scripts   # Re-apply without running scripts
   # Or:
   chezmoi destroy                    # Remove all chezmoi-managed files (nuclear option)
   ```

4. **Git config is gone:**
   ```sh
   cp ~/dotfiles-backup/.gitconfig ~/.gitconfig
   ```
