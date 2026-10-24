#!/usr/bin/env bash
# Installs the Turning Teams skill, turning-teams 0.3.1 (Apache License 2.0).
#
#   curl -fsSL https://turning.work/install.sh | bash
#   curl -fsSL https://turning.work/install.sh | bash -s codex
#   curl -fsSL https://turning.work/install.sh | bash -s /path/to/your/cli/skills
#
# With no argument it installs for Claude Code. It downloads the zip, checks
# its sha256, moves any earlier install to a backup outside the skill folders,
# and copies the new folder in, following the Install section of
# https://turning.work/skills/turning-teams/SKILL.md
#
# Everything runs inside one function, called with no arguments on the last
# line, so a download cut short runs none of the steps.
set -euo pipefail
turning_teams_target="${1:-claude}"

turning_teams_install() {
  local target="$turning_teams_target" skill_root sum work
  case "$target" in
    claude) skill_root="$HOME/.claude/skills" ;;
    codex) skill_root="$HOME/.agents/skills" ;;
    */*) skill_root="${target/#\~/$HOME}" ;;
    *)
      printf 'turning-teams: pass claude, codex or a folder path such as ./skills or ~/.config/agent/skills\n' >&2
      return 2
      ;;
  esac

  case "$skill_root" in
    /*) ;;
    *) skill_root="$PWD/$skill_root" ;;
  esac

  for tool in curl unzip; do
    if ! command -v "$tool" >/dev/null 2>&1; then
      printf 'turning-teams: %s is required\n' "$tool" >&2
      return 1
    fi
  done

  work=$(mktemp -d)
  cd "$work"
  curl -fsSLO https://turning.work/skills/turning-teams-0.3.1.zip

  if command -v sha256sum >/dev/null 2>&1; then
    sum=$(sha256sum turning-teams-0.3.1.zip)
  else
    sum=$(shasum -a 256 turning-teams-0.3.1.zip)
  fi

  if [ "${sum%% *}" != "4c052dd86c33ebcf327dfa1bac9e8b99d92849df99809d2f7bea0b22a272529d" ]; then
    printf 'turning-teams: the download does not match its sha256; nothing was installed\n' >&2
    return 1
  fi

  unzip -q turning-teams-0.3.1.zip
  TURN_SKILL_ROOT="$skill_root"
  mkdir -p "$TURN_SKILL_ROOT"
  if [ -e "$TURN_SKILL_ROOT/turning-teams" ] || [ -L "$TURN_SKILL_ROOT/turning-teams" ]; then
    TURN_SKILL_BACKUP=$(mktemp -d "$HOME/turning-teams-backup.XXXXXX")
    mv "$TURN_SKILL_ROOT/turning-teams" "$TURN_SKILL_BACKUP/turning-teams"
    printf 'Previous install saved in %s\n' "$TURN_SKILL_BACKUP/turning-teams"
  fi
  cp -R turning-teams "$TURN_SKILL_ROOT/turning-teams"
  printf 'Installed turning-teams 0.3.1 in %s\n' "$TURN_SKILL_ROOT/turning-teams"
  printf 'Start a new session and run /turning-teams in Claude Code or $turning-teams in Codex.\n'
}

turning_teams_install
