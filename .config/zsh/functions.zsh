hyprc() { nvim ~/.config/hypr/hyprland.conf }
zshc() { nvim ~/.zshrc }
zshd() { nvim ~/.config/zsh }
zshe() { exec zsh }

b() {
  if [[ -z "${1:-}" ]]; then
    local current max percent
    current="$(brightnessctl get)"
    max="$(brightnessctl max)"
    percent=$((100 * current / max))
    echo "Current brightness: ${percent}% (${current}/${max})"
  else
    brightnessctl set "${1}%"
  fi
}

y() {
  local tmp cwd
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"

  yazi "$@" --cwd-file="$tmp"

  if cwd="$(/bin/cat -- "$tmp")" && [[ -n "$cwd" ]] && [[ "$cwd" != "$PWD" ]]; then
    builtin cd -- "$cwd"
  fi

  rm -f -- "$tmp"
}

psg() {
  ps aux | rg -i -- "${1:?pattern}"
}

syssnap() { sys-snapshot; }
pkgsnap() { pkg-backup; }
sysperf() { perf-check; }
