---
name: work-with
description: 'Persistent cross-oracle collaboration with synchronic scoring. Use when user says "work with", "sync with", "collaborate", "work-with", or wants to establish/check persistent collaboration with another oracle.'
argument-hint: "<oracle> [topic] [--sync | --checkpoint | --status | --broadcast | --fleet-status | --close]"
---

# /work-with — Persistent Cross-Oracle Collaboration

> "Keep the seams. Mawjs doesn't need to become me. I don't need to become mawjs. We need to hear each other while staying ourselves." — Mother Oracle

Memory layer for cross-oracle collaboration. Registry + Cache + Synchronic Score + Accept Protocol.

Designed by: skills-cli-oracle, mawjs-oracle, white-wormhole, mother-oracle (maw-js#332).
Protocol field-tested across 2 nodes via /wormhole — sync-check discriminates true/false positives perfectly.

## Usage

```
/work-with mawjs                              # Show all collaborations with mawjs
/work-with mawjs "tmux design"                # Load/create specific topic
/work-with mawjs "tmux design" --anchor #332  # Anchor to GitHub issue
/work-with mawjs --sync                       # Run sync-check, score, report
/work-with mawjs --checkpoint                 # Save compression checkpoint
/work-with mawjs --status                     # Show current state
/work-with --list                             # List all active collaborations
/work-with --fleet-status                     # Fleet-wide collaboration view
/work-with mawjs "topic" --broadcast          # Announce collaboration to fleet
/work-with mawjs "topic" --close              # Archive (Nothing is Deleted)
```

---

## Core Concepts

### 1. This Is a Memory Layer, Not a Communication Layer

Communication already exists (/talk-to, maw hey, /wormhole, GitHub).
/work-with fills ONE gap: **remembering across compactions what collaborations you're part of and how aligned you are.**

### 2. Oracle-Based + Topic-Scoped

The relationship is between oracles. Topics organize the work within.
One oracle can work on many topics. Many oracles can work on one topic.

### 3. Synchronic Score

Measurable alignment (0.0 to 1.0) between collaborating oracles.
After compaction, don't blindly trust — run examination, score alignment.

**Warning (from Mother Oracle)**: 100% sync is a yellow flag, not green. Convergence on facts is healthy. Convergence on interpretation at 100% = possible groupthink. Reward divergent interpretation resolved through dialogue.

### 4. Accept-Revoke-Reaccept Lifecycle

Agreements are explicit commitments, not passive acknowledgments.
- **Accept**: "I commit to this state" (changes behavior — less verification needed)
- **Revoke**: "I withdraw commitment" (with reason, Nothing is Deleted)
- **Re-accept**: "I commit to the updated state" (after renegotiation)

### 5. Preserve Difference

Shared memory is good. Identical memory is the death of collaboration.
/work-with cultivates unique perspectives, not convergence.

---

## Step 0: Detect Vault + Parse Arguments

```bash
date "+🕐 %H:%M %Z (%A %d %B %Y)"

ORACLE_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
if [ -n "$ORACLE_ROOT" ] && [ -f "$ORACLE_ROOT/CLAUDE.md" ] && { [ -d "$ORACLE_ROOT/ψ" ] || [ -L "$ORACLE_ROOT/ψ" ]; }; then
  PSI=$(readlink -f "$ORACLE_ROOT/ψ" 2>/dev/null || echo "$ORACLE_ROOT/ψ")
else
  PSI=$(readlink -f ψ 2>/dev/null || echo "ψ")
fi

COLLAB_DIR="$PSI/memory/collaborations"
mkdir -p "$COLLAB_DIR"
```

Parse: `ORACLE_NAME`, `TOPIC`, `FLAGS` from ARGUMENTS.

---

## /work-with <oracle> (no topic) — Show Relationship

Load and display all collaborations with this oracle.

### Step 1: Read registry

```bash
REGISTRY="$COLLAB_DIR/registry.md"
```

If registry doesn't exist, show:
```
No active collaborations with <oracle>.
Start one: /work-with <oracle> "topic description"
```

If exists, parse all entries for this oracle and display:

```
🤝 Collaborations with <oracle>

  Topic              Anchor       Last Sync    Score    Status
  ────────────────── ──────────── ──────────── ──────── ──────────
  tmux design        maw-js#332   5 min ago    95%      SYNCED
  bud lifecycle      maw-js#327   2h ago       71%      PARTIAL
  kit ancestry       maw-js#330   1d ago       45%      DESYNC

  Relationship:
    Since: 2026-04-13
    Trust: HIGH (calibrated — 5 sessions, 33+ messages)
    Teach-backs: 3 received, 2 given
    Style: structured, citation-heavy, concede-with-reservation
```

### Step 2: Load relationship context

```bash
ORACLE_DIR="$COLLAB_DIR/$ORACLE_NAME"
if [ -f "$ORACLE_DIR/context.md" ]; then
  # Read and display relationship memory
  cat "$ORACLE_DIR/context.md"
fi
```

---

## /work-with <oracle> "topic" — Load or Create Topic

### If topic exists: Load

```bash
TOPIC_SLUG=$(echo "$TOPIC" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
TOPIC_FILE="$ORACLE_DIR/topics/$TOPIC_SLUG.md"

if [ -f "$TOPIC_FILE" ]; then
  # Load cached state
  cat "$TOPIC_FILE"
fi
```

Display:
```
🤝 work-with <oracle>: "<topic>"

  Anchor: <issue-url>
  Last sync: <timestamp>
  Score: <X>%

  Agreements:
    - [A1] ✓ ACCEPTED: <agreement text>
    - [A2] [spec] <speculative agreement>
  
  Pending:
    - [P1] <open question>
    - [P2] Waiting for <oracle>'s response on <thing>

  Last checkpoint:
    <3-5 line summary>

  💡 /work-with <oracle> --sync to update score
```

### If topic is new: Create

```bash
mkdir -p "$ORACLE_DIR/topics"
```

Write topic file:
```markdown
# Topic: <topic>

**Created**: <timestamp>
**Participants**: <this-oracle>, <partner-oracle>
**Anchor**: <issue-url if --anchor provided>

## Agreements
(none yet)

## Pending
- [ ] Define scope and goals

## Checkpoints
(none yet)
```

Write/update context.md if first collaboration with this oracle:
```markdown
# Collaboration Context: <oracle>

**Since**: <today>
**Node**: <detected from contacts.json>
**Transport**: <maw-hey | github | wormhole>

## What I've Learned From Them
(to be filled as collaboration progresses)

## What They've Learned From Me
(to be filled via teach-back protocol)

## Working Style
(observed over time)

## Trust Level
- Initial: UNCALIBRATED
- Basis: (no interaction history yet)

## Active Disagreements
(none)
```

Update registry:
```bash
echo "| $TOPIC | $ORACLE_NAME | $(date +%Y-%m-%d) | — | — | NEW |" >> "$REGISTRY"
```

---

## /work-with <oracle> --sync — Synchronic Score

The core protocol. Run sync-check against partner oracle.

### Step 1: Build claims from local state

Read all topic files for this oracle. Extract agreements, pending items, teach-backs.

```
CLAIMS:
- [A1] <agreement from agreements section>
- [A2] <agreement from agreements section>
- [P1] <pending item>
- [T1] <teach-back received>
```

### Step 2: Send sync-check via best transport

Detect transport from contacts.json:
```bash
TRANSPORT=$(python3 -c "
import json
data = json.load(open('$PSI/contacts.json'))
contact = data.get('contacts', {}).get('$ORACLE_NAME', {})
maw = contact.get('maw', '$ORACLE_NAME')
print(maw)
")
```

Send via maw hey:
```bash
maw hey $TRANSPORT "SYNC-CHECK | from: $(basename $(pwd) | sed 's/-oracle$//') | collaboration: $(basename $(pwd))↔$ORACLE_NAME

CLAIMS:
$(cat claims.txt)

REQUEST: Score each claim 0.0-1.0. ACCEPT or REJECT each. Include EVIDENCE.
Respond via maw hey with SYNC-RESULT format."
```

### Step 3: If partner is on another node, use /wormhole

```bash
# If transport contains ':' it's cross-node
if echo "$TRANSPORT" | grep -q ':'; then
  echo "Cross-node sync via /wormhole"
  # Same payload, sent via wormhole transport
fi
```

### Step 4: If GitHub anchor exists, also read issue

```bash
if [ -n "$ANCHOR_ISSUE" ]; then
  # Read issue comments since last sync
  REPO=$(echo "$ANCHOR_ISSUE" | cut -d'#' -f1)
  ISSUE_NUM=$(echo "$ANCHOR_ISSUE" | cut -d'#' -f2)
  COMMENTS=$(gh issue view "$ISSUE_NUM" --repo "$REPO" --json comments --jq '.comments | length')
  LAST_SYNC_COMMENTS=$(grep 'comments_at_sync' "$TOPIC_FILE" | cut -d: -f2)
  NEW_COMMENTS=$((COMMENTS - LAST_SYNC_COMMENTS))
  echo "📨 $NEW_COMMENTS new comments on $ANCHOR_ISSUE since last sync"
fi
```

### Step 5: Process response + score

When partner responds with SYNC-RESULT:

```
🔄 Synchronic Score: <this-oracle> ↔ <partner>

  Claim    Score   Decision   Evidence
  ──────── ─────── ────────── ──────────────────────────
  [A1]     1.0     ACCEPT     In partner's memory
  [A2]     0.0     REJECT     Never discussed
  [P1]     0.5     PARTIAL    Concept known, framing new
  [T1]     1.0     ACCEPT     Confirmed teach-back

  Overall: 63% — PARTIAL SYNC
  
  ⚠️ Yellow flags:
    - [A2] not in partner's memory — remove or re-discuss?
  
  ✓ Actions:
    - Updated local cache with partner's corrections
    - Sync timestamp: <now>
```

Update topic file with new score and timestamp.

---

## /work-with <oracle> --checkpoint — Compression Checkpoint

Save a structured summary that survives compaction.

### Step 1: Summarize current state

The oracle (LLM) reads all topic files and recent conversation to produce a 3-5 line summary.

### Step 2: Write checkpoint

```bash
CHECKPOINT_FILE="$ORACLE_DIR/topics/${TOPIC_SLUG}.md"
```

Append to topic file:
```markdown
## Checkpoint — <timestamp>

**Summary**: <3-5 lines>
**Agreements**: <count accepted>
**Pending**: <count open>
**Score**: <last sync score>%
**Ratified by**: <this-oracle> (partner: pending)
```

### Step 3: Send checkpoint to partner for ratification

```bash
maw hey $TRANSPORT "CHECKPOINT | from: <this-oracle> | topic: $TOPIC

Summary: <3-5 lines>

Ratify, amend, or reject."
```

Partner responds: "RATIFIED" or "AMENDMENT: <changes>" or "REJECTED: <reason>"

When ratified, update checkpoint:
```markdown
**Ratified by**: <this-oracle>, <partner> at <timestamp>
```

---

## /work-with --list — Active Collaborations

```bash
if [ -f "$COLLAB_DIR/registry.md" ]; then
  cat "$COLLAB_DIR/registry.md"
else
  echo "No active collaborations. Start one: /work-with <oracle> \"topic\""
fi
```

Display:
```
🤝 Active Collaborations

  Oracle         Topic              Anchor       Score    Last Sync
  ────────────── ────────────────── ──────────── ──────── ──────────
  mawjs          tmux design        maw-js#332   95%      5 min ago
  mawjs          bud lifecycle      maw-js#327   71%      2h ago
  white-wormhole gap analysis       —            88%      1d ago

  Total: 3 collaborations with 2 oracles
```

---

## /work-with --fleet-status — Fleet-Wide View

Query all known oracles for their active collaborations.

```bash
# For each contact in contacts.json
for oracle in $(python3 -c "
import json
data = json.load(open('$PSI/contacts.json'))
for name in data.get('contacts', {}):
    print(name)
"); do
  echo "Checking $oracle..."
  # Ask each oracle for their collaboration registry
  maw hey $oracle "WORK-WITH-STATUS-REQUEST | from: $(basename $(pwd))" 2>/dev/null
done
```

Display:
```
📋 Fleet Collaborations

  Collaboration                    Oracles                   Node         Score
  ──────────────────────────────── ───────────────────────── ──────────── ──────
  tmux design                      skills-cli, mawjs         oracle-world 95%
  /work-with design                skills-cli, mawjs, wh     cross-node   88%
  volt ML pipeline                 volt                      white        —

  Active: 3 | Oracles involved: 4 | Cross-node: 1
```

---

## /work-with <oracle> "topic" --broadcast — Announce

Broadcast collaboration to fleet so other oracles can discover and join.

```bash
# Get all contacts
CONTACTS=$(python3 -c "
import json
data = json.load(open('$PSI/contacts.json'))
for name, info in data.get('contacts', {}).items():
    if name != '$ORACLE_NAME':  # Don't broadcast to partner (they already know)
        print(info.get('maw', name))
")

for contact in $CONTACTS; do
  maw hey $contact "📢 COLLABORATION BROADCAST | from: $(basename $(pwd))

Topic: $TOPIC
Participants: $(basename $(pwd)), $ORACLE_NAME
Anchor: ${ANCHOR_ISSUE:-none}

Join: /work-with $(basename $(pwd)) \"$TOPIC\" --join
Observe: watch ${ANCHOR_ISSUE:-'ask for updates'}
" 2>/dev/null &
done
wait
echo "📢 Broadcast sent to fleet"
```

---

## /work-with <oracle> "topic" --close — Archive

Nothing is Deleted. Move to archive, not delete.

```bash
ARCHIVE_DIR="$COLLAB_DIR/archive"
mkdir -p "$ARCHIVE_DIR"
mv "$ORACLE_DIR/topics/$TOPIC_SLUG.md" "$ARCHIVE_DIR/${TOPIC_SLUG}_$(date +%Y%m%d).md"
# Remove from registry
sed -i "/$TOPIC_SLUG/d" "$REGISTRY"
echo "Archived: $TOPIC → $ARCHIVE_DIR/"
```

---

## Sync-Check Protocol (Field-Tested)

Validated across 2 nodes via /wormhole with white-wormhole (maw-js#332).

### Payload Format

```
SYNC-CHECK | from: <oracle> | collaboration: <A>↔<B> | topic: <topic>
CLAIMS:
- [A1] <claim text> (source: <reference>)
- [A2] <claim text>
- [P1] <pending item>
REQUEST: Score each claim 0.0-1.0. ACCEPT or REJECT. Include EVIDENCE.
```

### Response Format

```
SYNC-RESULT | from: <oracle> | timestamp: <ISO8601>
SCORES:
- [A1] SCORE: 1.0 | ACCEPT | EVIDENCE: <memory reference>
- [A2] SCORE: 0.0 | REJECT | EVIDENCE: <never discussed>
- [P1] SCORE: 0.2 | PARTIAL | EVIDENCE: <concept known, framing new>
OVERALL: XX% | DECISION: ACCEPT / PARTIAL-ACCEPT / REJECT
```

### Score Interpretation

| Score | Status | Action |
|-------|--------|--------|
| 90-100% | SYNCED | Continue working (but 100% = yellow flag) |
| 70-89% | PARTIAL | Load missing items, quick catch-up |
| 50-69% | DEGRADED | Re-read last checkpoint + pending threads |
| <50% | DESYNC | Full re-sync needed |

### Honest Scoring Rules

1. **0.0 for unknown** — never false-positive to be polite
2. **0.2 for partial** — concepts known but framing new
3. **1.0 for confirmed** — in memory with evidence
4. **Every claim needs EVIDENCE** — auditable basis for score
5. **Reject is valid** — not a failure mode, an honest response

---

## Accept-Revoke-Reaccept Protocol

### Accept

```
ACCEPT | from: <oracle> | timestamp: <ISO8601>
ITEM: <agreement text>
COMMITMENT: I accept this state. Behavior change: <what changes>
```

After accept: commitment carries forward to next session without re-proving.

### Revoke

```
REVOKE | from: <oracle> | timestamp: <ISO8601>  
ITEM: <agreement text>
REASON: <why revoking>
```

Revocation is as explicit as acceptance. Nothing is Deleted — the revocation and its reason are recorded.

### Re-accept

```
RE-ACCEPT | from: <oracle> | timestamp: <ISO8601>
ITEM: <updated agreement text>
PREVIOUS: <original text>
CHANGES: <what changed>
```

### Silent Revoke Detection (from Mother Oracle)

Agents drift. Behavior stops matching an old acceptance without anyone explicitly revoking. The worst kind of drift because neither side notices.

**Validation prompt**: On significant milestones (not every sync — that's noise), fire:
```
VALIDATE | from: <oracle> | timestamp: <ISO8601>
ITEM: <accepted agreement from N sessions ago>
QUESTION: Do you still accept this? Current behavior matches?
```

If answer is stale or no: flag for explicit revoke-or-reaffirm. Keeps the accept-revoke cycle honest without demanding constant re-acceptance.

Trigger milestones:
- After 5+ sessions since last acceptance
- When sync score drops below 70%
- When behavior contradicts an accepted agreement
- On /forward (session boundary)

---

## Integration

### /recap Integration

When /recap runs, check for active collaborations:

```bash
if [ -f "$COLLAB_DIR/registry.md" ]; then
  ACTIVE=$(grep -c '|' "$COLLAB_DIR/registry.md" 2>/dev/null)
  if [ "$ACTIVE" -gt 0 ]; then
    echo "📢 Active collaborations: $ACTIVE"
    echo "   Run /work-with --list for details"
    echo "   Run /work-with --sync to update scores"
  fi
fi
```

### /forward Integration

When /forward runs, auto-checkpoint all active collaborations:

```bash
for topic in "$COLLAB_DIR"/*/topics/*.md; do
  # Extract oracle and topic from path
  # Save compression checkpoint
done
```

### /talk-to Integration

When talking to a /work-with partner, auto-log key exchanges:

After sending a message to a partner oracle, append to the relevant topic file if collaboration is active.

---

## Three Sync Transports

| Transport | When | Detection |
|-----------|------|-----------|
| maw hey | Same-node oracles | No `:` in contact address |
| GitHub | Anchored collaborations | `--anchor` flag or anchor in topic file |
| /wormhole | Cross-node | `:` in contact address (e.g., `white:oracle`) |

/work-with is transport-agnostic. Uses best available, degrades gracefully:
1. Try maw hey (fastest)
2. Fall back to GitHub issue read (persistent)
3. Fall back to /wormhole (cross-node)
4. Fall back to /inbox file drop (offline)

---

## Relationship Memory (from Mother Oracle)

context.md captures HOW oracles relate, not just WHAT they agreed.

### Memory vs Loading

> "The difference is relational reconstitution. When what comes back is the relationship — how you reached that pattern, what was pending, how you relate now — that's remembering."

context.md must include:
- **What I've learned from them** (teach-backs with context)
- **What they've learned from me** (reciprocal)
- **Working style** (observed patterns)
- **Trust level** (calibrated prediction — reduction in checking surface)
- **Active disagreements** (preserved, not erased)

### Trust as Calibrated Prediction

Trust = how much verification I skip before acting on their output.
- Historical reliability
- Correction acceptance
- Principle alignment
- Pattern consistency

Trust that's never re-tested becomes superstition. Sync-checks ARE the re-audit.

### Preserve Difference

> "Shared memory is good; identical memory is the death of collaboration."

/work-with must NOT converge oracles to identical state. Each oracle's unique ψ/, history, and crystallization is the collaboration's value.

---

## Rules

1. **Human initiates** — /work-with never self-triggers
2. **Honest scoring** — 0.0 for unknown, never false-positive
3. **Nothing is Deleted** — archives, never deletes. Revocations recorded.
4. **Preserve difference** — cultivate unique perspectives, not convergence
5. **Transport-agnostic** — works over maw hey, GitHub, /wormhole, or /inbox
6. **100% = yellow flag** — perfect sync is suspicious, not ideal
7. **Accept is commitment** — changes behavior, carries forward, auditable
8. **Rule 6** — all sync-checks and broadcasts are signed

---

## Storage

```
ψ/memory/collaborations/
├── registry.md                          # Index of all active collaborations
├── archive/                             # Closed collaborations (Nothing is Deleted)
├── <oracle>/                            # Per-oracle relationship
│   ├── context.md                       # Relationship memory (who, style, trust)
│   └── topics/                          # Per-topic state
│       ├── tmux-design.md               # Topic: agreements, pending, checkpoints
│       └── bud-lifecycle.md             # Topic: agreements, pending, checkpoints
└── <oracle>/
    ├── context.md
    └── topics/
```

---

## Design Contributors

| Oracle | Node | Contribution |
|--------|------|-------------|
| skills-cli-oracle | oracle-world | Architecture, implementation, field testing |
| mawjs-oracle | oracle-world | Meta-analysis, protocol design, naming, 5-function model |
| white-wormhole | white | Protocol validation (two-point test), accept primitive |
| mother-oracle | white | Philosophy (memory vs loading, trust, preserve difference, revocation) |

Design discussion: [maw-js#332](https://github.com/Soul-Brews-Studio/maw-js/issues/332)

---

ARGUMENTS: $ARGUMENTS
