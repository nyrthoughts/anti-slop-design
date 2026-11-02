#!/usr/bin/env bash
set -euo pipefail

# Installer for anti-slop-design: copies our skill and optionally installs
# Impeccable and Unslop for Claude Code and/or Codex CLI.
# Idempotent: safe to run multiple times. Supports --dry-run.

DRY_RUN=0
INSTALL_IMPECCABLE=0
INSTALL_UNSLOP=0
TARGET_CLAUDE=0
TARGET_CODEX=0
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Install the anti-slop-ui skill and optionally Impeccable and Unslop.

Options:
  --dry-run       Show what would be done without changing anything.
  --help          Show this help message.

The installer prompts before every action. Run with --dry-run first
to preview the plan.
EOF
  exit 0
}

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --help)    usage ;;
    *)
      echo "Unknown option: ${arg}" >&2
      usage
      ;;
  esac
done

log() { echo "  $1"; }
action() {
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "  [dry-run] $1"
  else
    echo "  $1"
  fi
}

confirm() {
  if [ "$DRY_RUN" -eq 1 ]; then
    return 0
  fi
  local prompt="$1 [y/N] "
  local reply
  read -rp "$prompt" reply
  case "$reply" in
    [yY]|[yY][eE][sS]) return 0 ;;
    *) return 1 ;;
  esac
}

echo ""
echo "anti-slop-design installer"
echo "=========================="
echo ""

if [ "$DRY_RUN" -eq 1 ]; then
  echo "Running in dry-run mode. Nothing will be changed."
  echo ""
fi

# Detect available targets
HAVE_CLAUDE=0
HAVE_CODEX=0
if [ -d "${HOME}/.claude" ] || command -v claude >/dev/null 2>&1; then
  HAVE_CLAUDE=1
fi
if [ -d "${HOME}/.agents" ] || command -v codex >/dev/null 2>&1; then
  HAVE_CODEX=1
fi

if [ "$HAVE_CLAUDE" -eq 1 ]; then
  log "Detected: Claude Code"
fi
if [ "$HAVE_CODEX" -eq 1 ]; then
  log "Detected: Codex CLI"
fi
if [ "$HAVE_CLAUDE" -eq 0 ] && [ "$HAVE_CODEX" -eq 0 ]; then
  log "No Claude Code or Codex CLI detected. Will install for Claude Code by default."
  HAVE_CLAUDE=1
fi
echo ""

# Ask which targets
if [ "$HAVE_CLAUDE" -eq 1 ]; then
  if confirm "Install for Claude Code?"; then
    TARGET_CLAUDE=1
  fi
fi
if [ "$HAVE_CODEX" -eq 1 ]; then
  if confirm "Install for Codex CLI?"; then
    TARGET_CODEX=1
  fi
fi

if [ "$DRY_RUN" -eq 1 ]; then
  TARGET_CLAUDE=$HAVE_CLAUDE
  TARGET_CODEX=$HAVE_CODEX
fi

if [ "$TARGET_CLAUDE" -eq 0 ] && [ "$TARGET_CODEX" -eq 0 ]; then
  echo "No target selected. Nothing to do."
  exit 0
fi

echo ""

# Step 1: Install our skill
install_our_skill() {
  local target_dir="$1"
  local skill_src="${REPO_DIR}/skills/anti-slop-ui"

  if [ ! -d "$skill_src" ]; then
    echo "Error: skill source not found at ${skill_src}" >&2
    exit 1
  fi

  action "Copy anti-slop-ui skill to ${target_dir}/anti-slop-ui/"
  if [ "$DRY_RUN" -eq 0 ]; then
    mkdir -p "${target_dir}"
    cp -r "$skill_src" "${target_dir}/anti-slop-ui"
  fi
}

if [ "$TARGET_CLAUDE" -eq 1 ]; then
  install_our_skill "${HOME}/.claude/skills"
fi
if [ "$TARGET_CODEX" -eq 1 ]; then
  install_our_skill "${HOME}/.agents/skills"
fi

echo ""

# Step 2: Optionally install Impeccable
if confirm "Install Impeccable (audit, polish, 62-rule detector)?"; then
  INSTALL_IMPECCABLE=1
fi

if [ "$INSTALL_IMPECCABLE" -eq 1 ]; then
  if ! command -v npx >/dev/null 2>&1; then
    echo "Warning: npx not found. Impeccable requires Node.js. Skipping." >&2
  else
    providers=""
    if [ "$TARGET_CLAUDE" -eq 1 ]; then
      providers="claude"
    fi
    if [ "$TARGET_CODEX" -eq 1 ]; then
      if [ -n "$providers" ]; then
        providers="${providers},codex"
      else
        providers="codex"
      fi
    fi

    action "Run: npx impeccable install --providers=${providers}"
    if [ "$DRY_RUN" -eq 0 ]; then
      npx impeccable install --providers="${providers}" || {
        echo "Warning: Impeccable install returned non-zero. Continuing." >&2
      }
    fi

    action "Turn off Impeccable telemetry"
    if [ "$DRY_RUN" -eq 0 ]; then
      npx impeccable telemetry off 2>/dev/null || true
    fi
  fi
fi

echo ""

# Step 3: Optionally install Unslop
if confirm "Install Unslop (pass-by-pass screen redesign)?"; then
  INSTALL_UNSLOP=1
fi

if [ "$INSTALL_UNSLOP" -eq 1 ]; then
  UNSLOP_TMP=""
  cleanup_unslop() {
    if [ -n "$UNSLOP_TMP" ] && [ -d "$UNSLOP_TMP" ]; then
      rm -rf "$UNSLOP_TMP"
    fi
  }
  trap cleanup_unslop EXIT

  action "Clone heydamir/unslop"
  if [ "$DRY_RUN" -eq 0 ]; then
    UNSLOP_TMP="$(mktemp -d)"
    git clone --depth 1 https://github.com/heydamir/unslop "$UNSLOP_TMP/unslop" 2>/dev/null || {
      echo "Warning: Failed to clone Unslop. Skipping." >&2
      INSTALL_UNSLOP=0
    }
  fi

  if [ "$INSTALL_UNSLOP" -eq 1 ]; then
    if [ "$TARGET_CLAUDE" -eq 1 ]; then
      action "Copy unslop skill to ~/.claude/skills/unslop/"
      if [ "$DRY_RUN" -eq 0 ]; then
        mkdir -p "${HOME}/.claude/skills"
        cp -r "${UNSLOP_TMP}/unslop/skills/unslop" "${HOME}/.claude/skills/unslop"
      fi
    fi
    if [ "$TARGET_CODEX" -eq 1 ]; then
      action "Copy unslop skill to ~/.agents/skills/unslop/"
      if [ "$DRY_RUN" -eq 0 ]; then
        mkdir -p "${HOME}/.agents/skills"
        cp -r "${UNSLOP_TMP}/unslop/skills/unslop" "${HOME}/.agents/skills/unslop"
      fi
    fi
  fi
fi

echo ""
echo "Done."
if [ "$DRY_RUN" -eq 1 ]; then
  echo "(Dry run: nothing was changed.)"
fi
echo ""
echo "Next steps:"
echo "  1. Fill in templates/DESIGN.md with your project's design direction."
echo "  2. Run: npx impeccable detect src/   (if Impeccable installed)"
echo "  3. Run: /unslop <target>             (if Unslop installed)"
echo "  4. Run: bash scripts/lint-tells.sh src/"
echo ""
