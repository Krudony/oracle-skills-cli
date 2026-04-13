#!/usr/bin/env bash
# /team-agents killshot — kill ALL non-lead panes (nuclear option)
# Usage: bash ~/.claude/skills/team-agents/scripts/killshot.sh

SESSION=$(tmux display-message -p '#S' 2>/dev/null)
if [ -z "$SESSION" ]; then
  echo "Not in a tmux session"
  exit 0
fi

PANE_COUNT=$(tmux list-panes -t "$SESSION" | wc -l)

if [ "$PANE_COUNT" -le 1 ]; then
  echo "✅ Only 1 pane (lead) — nothing to kill"
  exit 0
fi

echo ""
echo "💀 Killshot — $SESSION"
echo ""

KILLED=0

# Work backwards to avoid index shifting
for i in $(seq $((PANE_COUNT - 1)) -1 1); do
  PANE_ID=$(tmux list-panes -t "$SESSION" -F "#{pane_index} #{pane_id}" 2>/dev/null | awk -v idx="$i" '$1==idx {print $2}')
  [ -z "$PANE_ID" ] && continue

  # Capture info before killing
  CAPTURE=$(tmux capture-pane -t "$SESSION:0.$i" -p 2>/dev/null | tail -3)
  MODEL=$(echo "$CAPTURE" | grep -oP '(Opus|Sonnet|Haiku) [0-9.]+' | head -1)
  [ -z "$MODEL" ] && MODEL="unknown"
  SIZE=$(tmux list-panes -t "$SESSION" -F "#{pane_index} #{pane_width}x#{pane_height}" 2>/dev/null | awk -v idx="$i" '$1==idx {print $2}')

  tmux kill-pane -t "$PANE_ID" 2>/dev/null
  printf "  Pane %-3s %-10s %-12s → killed\n" "$i" "$SIZE" "$MODEL"
  KILLED=$((KILLED + 1))
done

echo ""
echo "  Eliminated: $KILLED panes"
echo "  Remaining: 1 (lead only)"
echo ""
