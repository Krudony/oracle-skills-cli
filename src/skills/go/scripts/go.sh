#!/bin/bash
# /go — switch skill profiles
# Usage: go.sh <profile|full|reset> [+feature...]
# Profiles: minimal, standard, full, reset (alias for full)

SKILLS_DIR="${HOME}/.claude/skills"
ACTION="${1:-status}"

# Profile definitions
MINIMAL="forward rrr recap standup"
STANDARD="$MINIMAL trace dig learn talk-to oracle-family-scan"
SOUL="awaken philosophy who-are-you about-oracle birth feel"
NETWORK="talk-to oracle-family-scan oracle-soul-sync-update oracle oraclenet"
WORKSPACE="worktree physical schedule"
CREATOR="speak deep-research watch gemini"

# Always keep /go enabled
ALWAYS="go"

case "$ACTION" in
  minimal)  ENABLE="$MINIMAL $ALWAYS" ;;
  standard) ENABLE="$STANDARD $ALWAYS" ;;
  full|reset) ENABLE="__ALL__" ;;
  status)   ENABLE="__STATUS__" ;;
  *)        echo "Unknown profile: $ACTION"; exit 1 ;;
esac

# Handle features (+soul, +network, etc)
shift
while [ $# -gt 0 ]; do
  case "$1" in
    +soul|soul)       ENABLE="$ENABLE $SOUL" ;;
    +network|network) ENABLE="$ENABLE $NETWORK" ;;
    +workspace|workspace) ENABLE="$ENABLE $WORKSPACE" ;;
    +creator|creator) ENABLE="$ENABLE $CREATOR" ;;
    *) echo "Unknown feature: $1" ;;
  esac
  shift
done

enabled=0
disabled=0

echo ""

if [ "$ENABLE" = "__STATUS__" ]; then
  echo "  Oracle Skills"
  echo ""
  for dir in "$SKILLS_DIR"/*/; do
    skill=$(basename "$dir")
    [ "$skill" = "_shared" ] || [ "$skill" = "_template" ] && continue
    if [ -f "$dir/SKILL.md" ]; then
      printf "  ✓ %s\n" "$skill"
      enabled=$((enabled + 1))
    elif [ -f "$dir/SKILL.md.disabled" ]; then
      printf "  ✗ %s\n" "$skill"
      disabled=$((disabled + 1))
    fi
  done
  echo ""
  echo "  $enabled enabled, $disabled disabled."
  exit 0
fi

echo "  /go $ACTION"
echo ""

for dir in "$SKILLS_DIR"/*/; do
  skill=$(basename "$dir")
  [ "$skill" = "_shared" ] || [ "$skill" = "_template" ] && continue
  [ ! -f "$dir/SKILL.md" ] && [ ! -f "$dir/SKILL.md.disabled" ] && continue

  should_enable=false

  if [ "$ENABLE" = "__ALL__" ]; then
    should_enable=true
  else
    for s in $ENABLE; do
      if [ "$skill" = "$s" ]; then
        should_enable=true
        break
      fi
    done
  fi

  if $should_enable; then
    if [ -f "$dir/SKILL.md.disabled" ]; then
      mv "$dir/SKILL.md.disabled" "$dir/SKILL.md"
      printf "  ✓ %-25s (enabled)\n" "$skill"
    else
      printf "  ✓ %-25s (kept)\n" "$skill"
    fi
    enabled=$((enabled + 1))
  else
    if [ -f "$dir/SKILL.md" ]; then
      mv "$dir/SKILL.md" "$dir/SKILL.md.disabled"
      printf "  ✗ %-25s (disabled)\n" "$skill"
    else
      printf "  ✗ %-25s (kept disabled)\n" "$skill"
    fi
    disabled=$((disabled + 1))
  fi
done

echo ""
echo "  $enabled enabled, $disabled disabled. Restart session to apply."
