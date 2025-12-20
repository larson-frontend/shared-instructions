#!/usr/bin/env zsh
set -euo pipefail

# stats-agent-usage.sh
# Display fancy terminal output of agent usage statistics.
# Counts by model, task, status, and shows recent entries.

LOG_FILE="${1:-shared-instructions/docs/agent-usage.md}"

if [[ ! -f "$LOG_FILE" ]]; then
  echo "Error: agent-usage log not found: $LOG_FILE" >&2
  exit 1
fi

# Extract stats (skip header and format lines)
entries=$(grep "^\- \[" "$LOG_FILE" | wc -l)

# Count by model
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║           📊 Agent Usage Statistics                            ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "Total Entries: $entries"
echo ""

echo "┌─ By Model ─────────────────────────────────────────────────────┐"
grep "^\- \[" "$LOG_FILE" | grep -o "model=[^ ]*" | cut -d= -f2 | sort | uniq -c | \
  awk '{printf "│  %-35s %6d uses\n", $2, $1}' | sort -t'|' -k3 -rn
echo "└────────────────────────────────────────────────────────────────┘"
echo ""

echo "┌─ By Task Type ─────────────────────────────────────────────────┐"
grep "^\- \[" "$LOG_FILE" | grep -o "task=[^ ]*" | cut -d= -f2 | sort | uniq -c | \
  awk '{printf "│  %-35s %6d uses\n", $2, $1}' | sort -t'|' -k3 -rn
echo "└────────────────────────────────────────────────────────────────┘"
echo ""

echo "┌─ By Status ────────────────────────────────────────────────────┐"
grep "^\- \[" "$LOG_FILE" | grep -o "status=[^ ]*" | cut -d= -f2 | sort | uniq -c | \
  awk '{printf "│  %-35s %6d uses\n", $2, $1}' | sort -t'|' -k3 -rn
echo "└────────────────────────────────────────────────────────────────┘"
echo ""

echo "┌─ Recent 5 Entries ────────────────────────────────────────────┐"
tail -5 "$LOG_FILE" | while IFS= read -r line; do
  [[ "$line" =~ ^\- ]] && printf "│  %s\n" "${line:2}" || true
done
echo "└────────────────────────────────────────────────────────────────┘"
echo ""
