#!/usr/bin/env zsh
set -euo pipefail

git_dir="/home/kaue/.dotfiles"
work_tree="/home/kaue"
git_bin="/bin/git"

paths=(
  ".zshrc"
  ".zprofile"
  ".p10k.zsh"
  ".gitconfig"
  ".gitignore"
  ".tmux.conf"
  ".gtkrc-2.0"
  ".config/btop"
  ".config/ghostty"
  ".config/kitty"
  ".config/lazygit"
  ".config/nvim"
  ".config/systemd/user/plasma-kwin_wayland.service.d/override.conf"
)

apply=0
if [[ "${1:-}" == "--apply" ]]; then
  apply=1
fi

existing=()
missing=()
for path in "${paths[@]}"; do
  if [[ -e "${work_tree}/${path}" ]]; then
    existing+=("${path}")
  else
    missing+=("${path}")
  fi
done

echo "Git dir: ${git_dir}"
echo "Work tree: ${work_tree}"
echo
echo "Starter candidates found:"
for path in "${existing[@]}"; do
  echo "  ${path}"
done

if (( ${#missing[@]} > 0 )); then
  echo
  echo "Missing candidates skipped:"
  for path in "${missing[@]}"; do
    echo "  ${path}"
  done
fi

if (( apply == 0 )); then
  echo
  echo "Dry run only. Re-run with --apply to stage these paths."
  exit 0
fi

if (( ${#existing[@]} == 0 )); then
  echo
  echo "Nothing to stage."
  exit 0
fi

echo
echo "Staging starter set into bare repo..."
cd "${work_tree}"
"${git_bin}" --git-dir="${git_dir}" --work-tree="${work_tree}" add -- "${existing[@]}"
echo "Done."
