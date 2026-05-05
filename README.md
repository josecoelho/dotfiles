# dotfiles

Personal dotfiles managed via [GNU Stow](https://www.gnu.org/software/stow/).
Each top-level directory is a stow "package" — its contents mirror the layout
under `$HOME`. Running `stow <package>` symlinks every file in that package
into the matching path under `$HOME`.

## Layout

```
.
├── install.sh                   # full installer (packages + stow)
├── shell/
│   └── .zshrc                  → ~/.zshrc
├── tmux/
│   └── .tmux.conf              → ~/.tmux.conf
├── nvim/
│   └── .config/
│       └── nvim/...            → ~/.config/nvim/...   (NvChad-based)
└── git/
    ├── .gitconfig              → ~/.gitconfig         (base config)
    └── .config/
        └── git/
            └── ignore          → ~/.config/git/ignore
```

## Install

Full setup (laptop, fresh machine):

```bash
git clone https://github.com/josecoelho/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

The script installs Homebrew or apt packages (zsh, tmux, neovim, ripgrep,
mise, tailscale, stow) for the detected OS, then stows every package.

Container / minimal mode (skips package installs, just stows):

```bash
DOTFILES_CONTAINER=1 ./install.sh
```

## Adding a new config

```bash
mkdir alacritty                                              # new package
mkdir -p alacritty/.config/alacritty
cp ~/.config/alacritty/alacritty.yml alacritty/.config/alacritty/
./install.sh                                                 # re-stow
```

The directory layout under each package mirrors `$HOME`. Whatever path you
want symlinked at `~/.foo/bar/baz`, place it at `<package>/.foo/bar/baz`.

## Per-machine git config (`~/.gitconfig.local`)

The base `git/.gitconfig` is portable — it has no user identity, no
signing keys, no machine-specific paths. All of that goes in
`~/.gitconfig.local`, which is never committed.

**Minimum on a fresh machine:**

```ini
[user]
	email = your@email.example
	name = Your Name
```

Without this file your commits will use whatever default git falls
back to, or fail. The base config pulls it in via `[include]`.

**Signing on a laptop with a GPG key:**

```ini
[commit]
	gpgsign = true
[user]
	signingkey = <YOUR_GPG_FINGERPRINT>
[gpg]
	program = gpg
```

**Dev container with SSH signing:** when DOTFILES_CONTAINER mode is
used, the host wires `~/.gitconfig.local` automatically against an
SSH signing key mounted into the container — no manual step.

**Personal-identity routing for non-work projects:**

```ini
[includeIf "gitdir:~/personal/"]
	path = ~/.gitconfig-personal
```

Then `~/.gitconfig-personal` (also gitignored, machine-local):

```ini
[user]
	email = me@example.com
	name = Your Name
```

