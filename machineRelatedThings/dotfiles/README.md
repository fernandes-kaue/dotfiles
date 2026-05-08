# Dotfiles Bare Repo Setup

This workspace contains a safe starter flow for the bare dotfiles repo at:

- Git dir: `/home/kaue/.dotfiles`
- Work tree: `/home/kaue`

## Current state

- The bare repo already exists and is configured with `bare = true`.
- The shell alias already exists in `~/.zshrc`:
  `alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'`
- The repo already tracks shell, terminal, editor, systemd user, and utility script files.
- `origin` is configured as `https://github.com/fernandes-kaue/dotfiles.git`.

## Recommended starter set for additional imports

These are still good candidates because they are usually portable and user-authored:

- `~/.zshrc`
- `~/.zprofile`
- `~/.p10k.zsh`
- `~/.gitconfig`
- `~/.gitignore`
- `~/.tmux.conf`
- `~/.gtkrc-2.0`
- `~/.config/btop`
- `~/.config/ghostty`
- `~/.config/kitty`
- `~/.config/lazygit`
- `~/.config/nvim`
- `~/.config/systemd/user/plasma-kwin_wayland.service.d/override.conf`

## Avoid tracking by default

These are commonly sensitive, noisy, or machine-specific:

- `~/.git-credentials`
- `~/.ssh`
- `~/.gnupg`
- `~/.npmrc`
- `~/.pki`
- `~/.config/rclone/rclone.conf`
- `~/.cache`
- `~/.local/share`
- `~/.local/state`
- browser profiles
- editor extension caches
- KDE display layout files like `~/.config/kwinoutputconfig.json`

## Bootstrap flow for additional starter paths

Preview the starter set:

```zsh
zsh /home/kaue/machineRelatedThings/dotfiles/bootstrap-starter.sh
```

Stage the starter set into the bare repo:

```zsh
zsh /home/kaue/machineRelatedThings/dotfiles/bootstrap-starter.sh --apply
```

Review the staged result:

```zsh
git --git-dir=/home/kaue/.dotfiles --work-tree=/home/kaue status --short
```

Create a commit after reviewing staged changes:

```zsh
git --git-dir=/home/kaue/.dotfiles --work-tree=/home/kaue commit -m "chore: update dotfiles"
```

## Neovim config

The active Neovim config lives at `~/.config/nvim` and is tracked by the bare
dotfiles repo. A copy is also kept in this workspace at
`/home/kaue/machineRelatedThings/dotfiles/nvim` for local review.

To restore the workspace copy into the live config:

```zsh
mkdir -p ~/.config/nvim
cp -a /home/kaue/machineRelatedThings/dotfiles/nvim/. ~/.config/nvim/
```

After restoring, install the declared plugins and Mason tools:

```zsh
nvim --headless "+Lazy! sync" +qa
nvim --headless "+MasonInstall bash-language-server docker-compose-language-service dockerfile-language-server eslint-lsp hadolint intelephense java-debug-adapter java-test js-debug-adapter php-cs-fixer php-debug-adapter phpcs prisma-language-server shellcheck sqlls sqlfluff taplo yaml-language-server" +qa
```

If you need to replace or add a remote later:

```zsh
git --git-dir=/home/kaue/.dotfiles --work-tree=/home/kaue remote add origin git@github.com:<user>/<repo>.git
git --git-dir=/home/kaue/.dotfiles --work-tree=/home/kaue push -u origin main
```

## New machine restore

Typical restore flow:

```zsh
git clone --bare git@github.com:<user>/<repo>.git /home/kaue/.dotfiles
git --git-dir=/home/kaue/.dotfiles --work-tree=/home/kaue checkout
git --git-dir=/home/kaue/.dotfiles --work-tree=/home/kaue config status.showUntrackedFiles no
```
