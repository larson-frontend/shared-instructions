#!/usr/bin/env zsh
set -uo pipefail

# stats-agent-usage-pie.sh
# Display agent usage statistics with ASCII pie charts and percentages.

SCRIPT_DIR=$(cd -- "$(dirname "$0")" && pwd)
DEFAULT_LOG="$SCRIPT_DIR/../docs/agent-usage.md"
LOG_FILE="${1:-$DEFAULT_LOG}"

if [[ ! -f "$LOG_FILE" ]]; then
  echo "Error: agent-usage log not found: $LOG_FILE" >&2
  exit 1
fi

# Extract stats (skip header and format lines)
entries=$(grep -E "^\- \[" "$LOG_FILE" | wc -l | tr -d ' ')

if [[ -z "$entries" || "$entries" == "0" ]]; then
  echo "No entries logged yet. Add entries with log-agent-usage.sh first." >&2
  exit 0
fi

# Helper: Draw ASCII pie segment
draw_pie() {
  local pct=$1
  local label=$2

  # ASCII ring bar (40 chars) using '#' for filled and '.' for remaining.
  local filled=$(( (pct * 40) / 100 ))
  local empty=$(( 40 - filled ))
  local bar=$(printf '%*s' "$filled" | tr ' ' '#')
  local empty_bar=$(printf '%*s' "$empty" | tr ' ' '.')

  printf "  %-18s (%s%s) %3d%%\n" "$label" "$bar" "$empty_bar" "$pct"
}

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║           📊 Agent Usage Statistics                            ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "Total Uses: $entries"
echo ""

# Generic counter extractor for a given key (model/task/status)
extract_counts() {
  local key=$1
  awk -v key="$key" 'NR>0 {
    if ($0 ~ /^- \[/) {
      for (i = 1; i <= NF; i++) {
        if ($i ~ "^" key "=") {
          split($i, a, "=")
          print a[2]
        }
      }
    }
  }' "$LOG_FILE" | sort | uniq -c
}

render_section() {
  local title=$1
  local key=$2

  echo "┌─ ${title} ──────────────────────────────────────────┐"
  local counts
  counts=$(extract_counts "$key")

  if [[ -z "$counts" ]]; then
    echo "│  (no data)"
    echo "└────────────────────────────────────────────────────────────────┘"
    echo ""
    return
  fi

  while read -r count label; do
    [[ -z "$label" ]] && continue
    pct=$(( (count * 100) / entries ))
    draw_pie "$pct" "$label" "none"
  done <<< "$counts"

  echo "└────────────────────────────────────────────────────────────────┘"
  echo ""
}

# By Model (pie chart)
render_section "Model Distribution" "model"

# By Task Type (pie chart)
render_section "Task Type Distribution" "task"

# By Status (pie chart)
render_section "Status Distribution" "status"

# Recent 5 entries
echo "┌─ Recent 5 Entries ────────────────────────────────────────────┐"
tail -5 "$LOG_FILE" | while IFS= read -r line; do
  [[ "$line" =~ ^\- ]] && printf "│  %s\n" "${line:2}" || true
done
echo "└────────────────────────────────────────────────────────────────┘"
echo ""
