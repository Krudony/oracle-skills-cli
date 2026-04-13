#!/usr/bin/env bash
# /team-agents cleanup helper — kill orphaned agent panes after team shutdown
# Usage: bash ~/.claude/skills/team-agents/scripts/cleanup.sh [--dry-run]
#
# Finds panes that were team agents (not the lead, not pre-existing)
# and kills them. Safe — only kills panes with idle claude prompts.

DRY_RUN=false
[ "$1" = "--dry-run" ] && DRY_RUN=true

SESSION=$(tmux display-message -p '#S' 2>/dev/null)
if [ -z "$SESSION" ]; then
  echo "Not in a tmux session"
  exit 0
fi

PANE_COUNT=$(tmux list-panes -t "$SESSION" | wc -l)

if [ "$PANE_COUNT" -le 1 ]; then
  echo "✅ Only 1 pane (lead) — nothing to clean"
  exit 0
fi

echo ""
echo "🧹 Cleanup — $SESSION ($PANE_COUNT panes)"
echo ""

KILLED=0
SKIPPED=0

# Work backwards (highest pane first) so killing doesn't shift indices
for i in $(seq $((PANE_COUNT - 1)) -1 1); do
  PANE_ID=$(tmux list-panes -t "$SESSION" -F "#{pane_index} #{pane_id}" 2>/dev/null | awk -v idx="$i" '$1==idx {print $2}')
  [ -z "$PANE_ID" ] && continue

  # Capture last 3 lines
  CAPTURE=$(tmux capture-pane -t "$SESSION:0.$i" -p 2>/dev/null | tail -3)

  # Extract info
  MODEL=$(echo "$CAPTURE" | grep -oP '(Opus|Sonnet|Haiku) [0-9.]+' | head -1)
  [ -z "$MODEL" ] && MODEL="unknown"
  SIZE=$(tmux list-panes -t "$SESSION" -F "#{pane_index} #{pane_width}x#{pane_height}" 2>/dev/null | awk -v idx="$i" '$1==idx {print $2}')

  # Check if idle (has ❯ prompt = safe to kill)
  if echo "$CAPTURE" | grep -q '^❯'; then
    STATUS="idle"
  else
    STATUS="active"
  fi

  printf "  Pane %-3s %-10s %-12s %s" "$i" "$SIZE" "$MODEL" "$STATUS"

  if [ "$STATUS" = "idle" ]; then
    if [ "$DRY_RUN" = true ]; then
      echo "  → would kill"
    else
      tmux kill-pane -t "$PANE_ID" 2>/dev/null
      echo "  → killed"
    fi
    KILLED=$((KILLED + 1))
  else
    echo "  → skipped (still active)"
    SKIPPED=$((SKIPPED + 1))
  fi
done

echo ""
if [ "$DRY_RUN" = true ]; then
  echo "  Dry run: would kill $KILLED idle panes, skip $SKIPPED active"
  echo "  Run without --dry-run to execute"
else
  echo "  Killed: $KILLED | Skipped: $SKIPPED active"
  REMAINING=$(tmux list-panes -t "$SESSION" | wc -l)
  echo "  Panes remaining: $REMAINING"
fi
echo ""
