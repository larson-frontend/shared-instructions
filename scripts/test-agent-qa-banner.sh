#!/usr/bin/env bash
set -euo pipefail

# test-agent-qa-banner.sh
# Fancy terminal banner similar in spirit to Spring Boot startup banners.
# Prints a big boxed header and key-value lines.
#
# Usage:
#   ./shared-instructions/scripts/test-agent-qa-banner.sh \
#     --agent "Magic Agent" --task "code" --model "claude-sonnet-4.5" \
#     --status "TEST" --reason "Preview header"
#
# All args optional. Defaults:
#   agent=Magic Agent, status=TEST, task="", model="", reason=""

AGENT="Magic Agent"
TASK=""
MODEL=""
STATUS="TEST"
REASON=""
TIME_UTC=$(date -u +%Y-%m-%dT%H:%M:%SZ)

while [[ $# -gt 0 ]]; do
  case "$1" in
    --agent) AGENT=${2:-"$AGENT"}; shift 2;;
    --task) TASK=${2:-"$TASK"}; shift 2;;
    --model) MODEL=${2:-"$MODEL"}; shift 2;;
    --status) STATUS=${2:-"$STATUS"}; shift 2;;
    --reason) REASON=${2:-"$REASON"}; shift 2;;
    *) echo "Unknown arg: $1" >&2; exit 2;;
  esac
done

# Colors only if stdout is a terminal
if [ -t 1 ]; then
  C1="\033[1;95m"  # magenta bright
  C2="\033[1;96m"  # cyan bright
  C3="\033[1;93m"  # yellow bright
  C4="\033[1;92m"  # green bright
  R="\033[0m"
else
  C1=""; C2=""; C3=""; C4=""; R=""
fi

# Box width (characters). Adjust if you change the title length.
BOX_WIDTH=47
TITLE="TEST AGENT QA"

pad_center() {
  local text="$1"; local width=$2
  local text_len=${#text}
  if (( text_len >= width )); then echo "$text"; return; fi
  local pad=$(( (width - text_len) / 2 ))
  local extra=$(( (width - text_len) - pad ))
  printf '%*s%s%*s' "$pad" '' "$text" "$extra" ''
}

# ASCII Art banner (TAAG-style, font: Big)
cat <<'BANNER'
  _______ ______  _____ _______              
 |__   __|  ____|/ ____|__   __|             
    | |  | |__  | (___    | |                
    | |  |  __|  \___ \   | |                
    | |  | |____ ____) |  | |                
    |_|  |______|_____/   |_|                
                                             
            ___    ______ ______ _   _ _______ 
           /   \  / _____|  ____| \ | |__   __|
          / /_\ \| |  __ | |__  |  \| |  | |   
         /  _  _ \ |  |_ ||  __| | . ` |  | |   
        /  / | | || |__| || |____| |\  |  | |   
       /__/  |_|_| \_____|______|_| \_|  |_|   
                                             
             ____      ___                   
            / __ \    / _ \                  
           | |  | |  / /_\ \                 
           | |  | | /  _  _ \                
           | |__| |/  / | | |                
            \___\_/__/  |_|_|                
BANNER

# Details lines (like Spring Boot’s info block, but agent-oriented)
[[ -n "$AGENT" ]] && echo -e "${C4}Agent:${R} $AGENT"
[[ -n "$TASK"  ]] && echo -e "${C3}Task:${R}  $TASK"
[[ -n "$MODEL" ]] && echo -e "${C3}Model:${R} $MODEL"
[[ -n "$STATUS" ]] && echo -e "${C3}Status:${R} $STATUS"
echo -e "${C3}Time:${R}   $TIME_UTC"
[[ -n "$REASON" ]] && echo -e "${C3}Reason:${R} $REASON"

exit 0
