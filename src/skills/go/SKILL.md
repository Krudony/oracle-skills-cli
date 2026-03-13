---
name: go
description: Switch skill profiles and features. Enable/disable skills instantly. Use when user says "go", "go minimal", "go standard", "go + soul", "switch profile", "enable skills", "disable skills".
---

# /go

> Switch gear. Nothing deleted.

## Usage

```
/go                     # show current state
/go minimal             # switch to minimal (4 skills)
/go standard            # switch to standard (9 skills)
/go full                # enable everything (30 skills)
/go reset               # alias for /go full
/go + soul              # add soul feature
/go + creator network   # add multiple features
/go - workspace         # remove feature
/go enable trace dig    # enable specific skills
/go disable watch       # disable specific skills
```

---

## Execution — profile/status commands

For `/go`, `/go <profile>`, `/go reset`, and `/go full` — **run the shell script**:

```bash
bash ~/.claude/skills/go/scripts/go.sh <profile>
```

**IMPORTANT**: Always use `bash` explicitly. Do NOT use `zsh` or `sh` — the script relies on bash word splitting.

Examples:
- `/go` → `bash ~/.claude/skills/go/scripts/go.sh`
- `/go standard` → `bash ~/.claude/skills/go/scripts/go.sh standard`
- `/go full` → `bash ~/.claude/skills/go/scripts/go.sh full`
- `/go reset` → `bash ~/.claude/skills/go/scripts/go.sh reset`
- `/go standard +soul` → `bash ~/.claude/skills/go/scripts/go.sh standard +soul`

For `/go enable`, `/go disable`, `/go +`, `/go -` — follow the manual instructions below.

---

## /go (no args) — show current state

Run: `bash ~/.claude/skills/go/scripts/go.sh`

Or scan manually:

```bash
ls ~/.claude/skills/*/SKILL.md ~/.claude/skills/*/SKILL.md.disabled 2>/dev/null
```

Display:

```
Oracle Skills — 12 enabled, 18 disabled

Profile: standard
Features: +soul

  ✓ forward        minimal
  ✓ rrr            minimal
  ✓ recap          minimal
  ✓ standup        minimal
  ✓ trace          standard
  ✓ dig            standard
  ✓ learn          standard
  ✓ talk-to        standard
  ✓ oracle-family-scan  standard
  ✓ awaken         +soul
  ✓ philosophy     +soul
  ✓ who-are-you    +soul
  ✗ worktree       [workspace]
  ✗ oraclenet      [network]
  ✗ speak          [creator]
  ...

/go + creator     to add creator skills
/go full          to enable everything
```

---

## /go \<profile\> — switch profile

Profiles are tiers. Switching enables the profile's skills and disables the rest.

| Profile | Skills |
|---------|--------|
| **minimal** | `forward`, `rrr`, `recap`, `standup` |
| **standard** | minimal + `trace`, `dig`, `learn`, `talk-to`, `oracle-family-scan` |
| **full** | all 30 skills |
| **reset** | alias for `full` — enable everything |

### How it works

For each skill in `~/.claude/skills/`:

```bash
# If skill should be enabled (in profile set):
#   SKILL.md.disabled → SKILL.md

# If skill should be disabled (not in profile set):
#   SKILL.md → SKILL.md.disabled
```

**Nothing is deleted.** Disabled = renamed. Ready to re-enable instantly.

Show the change:

```
/go minimal

  ✓ forward          (kept)
  ✓ rrr              (kept)
  ✓ recap            (kept)
  ✓ standup          (kept)
  ✗ trace            disabled
  ✗ dig              disabled
  ✗ learn            disabled
  ...

4 enabled, 26 disabled. Restart session to apply.
```

---

## /go + \<feature\> — add feature

Features are add-on modules. Adding enables those skills on top of current state.

| Feature | Skills |
|---------|--------|
| **soul** | `awaken`, `philosophy`, `who-are-you`, `about-oracle`, `birth`, `feel` |
| **network** | `talk-to`, `oracle-family-scan`, `oracle-soul-sync-update`, `oracle`, `oraclenet` |
| **workspace** | `worktree`, `physical`, `schedule` |
| **creator** | `speak`, `deep-research`, `watch`, `gemini` |

```bash
# Enable all skills in the feature (SKILL.md.disabled → SKILL.md)
```

Multiple features at once: `/go + soul creator`

---

## /go - \<feature\> — remove feature

Disable feature skills (only those not in the active profile).

```bash
# Disable feature skills that aren't part of the base profile
```

---

## /go enable \<skill...\> — enable specific

```bash
# For each skill:
#   ~/.claude/skills/<name>/SKILL.md.disabled → SKILL.md
```

Example: `/go enable trace worktree speak`

---

## /go disable \<skill...\> — disable specific

```bash
# For each skill:
#   ~/.claude/skills/<name>/SKILL.md → SKILL.md.disabled
```

Example: `/go disable oraclenet deep-research`

**Nothing is deleted.** `/go enable oraclenet` brings it right back.

---

## Composable examples

```
/go minimal                    → 4 skills (daily ritual only)
/go minimal + soul             → 10 skills (community oracle)
/go minimal + creator          → 8 skills (content creator)
/go standard                   → 9 skills (daily driver)
/go standard + network         → 14 skills (oracle developer)
/go standard + workspace       → 12 skills (parallel agents)
/go full                       → 30 skills (everything)
/go reset                      → same as /go full
```

---

## Rules

1. **Nothing is deleted** — disable = rename, not uninstall
2. **Restart required** — Claude loads skills at session start, changes apply next session
3. **Idempotent** — enabling an already-enabled skill is a no-op
4. **Profile + features stack** — features add on top, never subtract from profile base
5. Show count at the end: `N enabled, M disabled`

---

ARGUMENTS: $ARGUMENTS
