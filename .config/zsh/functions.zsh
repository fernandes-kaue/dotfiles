hyprc() { nvim ~/.config/hypr/hyprland.conf }
zshc() { cd ~/.config/zsh}
zshe() { exec zsh }

b() {
  local current max percent target

  if [[ "${1:-}" == "status" ]]; then
    current="$(/usr/bin/brightnessctl get)"
    max="$(/usr/bin/brightnessctl max)"
    percent=$((100 * current / max))
    echo "Current brightness: ${percent}% (${current}/${max})"
  else
    /usr/bin/brightnessctl set "${1:-100}%"
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
backuphome() { backup-home "$@"; }
secretscan() { dotfiles-secret-scan "${1:-staged}"; }
repostatus() { repo-status; }
cachereport() { cache-report; }
bootr() { boot-report; }
logtriage() { log-triage "${1:-2h}"; }
timerls() { systemctl --user list-timers --all; }
svcfailed() { systemctl --failed --no-legend; echo; systemctl --user --failed --no-legend; }
jwarn() { journalctl -b -p warning..alert --no-pager | tail -n "${1:-80}"; }
gpu() {
  lspci | rg 'VGA|3D|Display' || true
  echo
  nvidia-smi 2>/dev/null || echo "nvidia-smi not available"
}
dotstaged() { /bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME diff --cached --stat; }
