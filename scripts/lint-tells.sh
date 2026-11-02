#!/usr/bin/env bash
set -euo pipefail

# lint-tells.sh -- Zero-dependency grep-based checker for cheap AI tells.
# Scans source files for patterns that signal AI-generated UI.
# Exit 0: clean. Exit 1: findings. Exit 2: usage error.

usage() {
  cat <<EOF
Usage: $(basename "$0") <path> [path...]

Scan files for common AI-generated UI tells. Accepts files or directories.
Directories are searched recursively for .jsx, .tsx, .html, .vue, .svelte files.

Exit codes:
  0  No findings
  1  Findings detected
  2  Usage error
EOF
  exit 2
}

if [ $# -eq 0 ]; then
  usage
fi

FINDINGS=0
FIND_COUNT=0

FILE_EXTENSIONS=("jsx" "tsx" "html" "vue" "svelte" "astro" "css")

report() {
  local filepath="$1"
  local line_num="$2"
  local rule="$3"
  local line_text="$4"
  echo "${filepath}:${line_num}: [${rule}] ${line_text}"
  FINDINGS=1
  FIND_COUNT=$((FIND_COUNT + 1))
}

scan_line() {
  local filepath="$1"
  local line_num="$2"
  local line="$3"

  if echo "$line" | grep -qE 'transition-all|transition:\s*all'; then
    report "$filepath" "$line_num" "transition-all" "$line"
  fi

  if echo "$line" | grep -qE 'animate-pulse'; then
    if ! echo "$line" | grep -qiE 'skeleton|loader|loading'; then
      report "$filepath" "$line_num" "animate-pulse-non-loader" "$line"
    fi
  fi

  if echo "$line" | grep -qE 'hover:scale'; then
    report "$filepath" "$line_num" "hover-scale" "$line"
  fi

  if echo "$line" | grep -qE 'bg-clip-text\s+text-transparent|bg-gradient.*text-transparent|-webkit-background-clip:\s*text'; then
    report "$filepath" "$line_num" "gradient-text" "$line"
  fi

  if echo "$line" | grep -qP '[\x{1F680}\x{2728}\x{1F44B}\x{1F525}\x{2B50}\x{2705}\x{1F389}\x{1F4A1}\x{1F31F}\x{270C}\x{1F4AA}]'; then
    report "$filepath" "$line_num" "emoji-in-text" "$line"
  fi

  if echo "$line" | grep -qiE 'Welcome\s+back'; then
    report "$filepath" "$line_num" "welcome-back" "$line"
  fi

  if echo "$line" | grep -qiE '(>|"|'"'"'|`)\s*(Supercharge|Unlock\s+(the|your|premium)|Revolutionize)'; then
    report "$filepath" "$line_num" "hype-word" "$line"
  fi

  if echo "$line" | grep -qE '(mt|mb|ml|mr|mx|my|pt|pb|pl|pr|px|py|gap|space-[xy])-\[[0-9]+px\]'; then
    report "$filepath" "$line_num" "arbitrary-spacing" "$line"
  fi
}

check_file() {
  local filepath="$1"
  local lines=()
  mapfile -t lines < "$filepath"
  local i
  for i in "${!lines[@]}"; do
    scan_line "$filepath" "$((i + 1))" "${lines[$i]}"
  done
}

collect_files() {
  local target="$1"
  if [ -f "$target" ]; then
    echo "$target"
  elif [ -d "$target" ]; then
    for ext in "${FILE_EXTENSIONS[@]}"; do
      find "$target" -type f -name "*.${ext}" 2>/dev/null || true
    done
  else
    echo "Warning: ${target} is not a file or directory, skipping." >&2
  fi
}

ALL_FILES=()
for target in "$@"; do
  while IFS= read -r f; do
    if [ -n "$f" ]; then
      ALL_FILES+=("$f")
    fi
  done < <(collect_files "$target")
done

if [ ${#ALL_FILES[@]} -eq 0 ]; then
  echo "No matching files found."
  exit 0
fi

for filepath in "${ALL_FILES[@]}"; do
  check_file "$filepath"
done

if [ "$FINDINGS" -eq 1 ]; then
  echo ""
  echo "${FIND_COUNT} finding(s) detected."
  exit 1
else
  echo "No AI tells found."
  exit 0
fi
