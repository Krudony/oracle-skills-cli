---
description: '[core] v3.4.10 | X-ray deep scan — inspect Claude Code auto-memory, installed skills, or session history. Use when user says "xray", "x-ray", "memory", "scan memory", "what do you remember", "show memories", "memory stats", "forget", "list skills", "installed skills", "session history", or wants to inspect what the AI remembers across sessions. Do NOT trigger for Oracle vault/ψ (use /trace) or session handoffs (use /inbox).'
argument-hint: "[memory|skills|sessions]"
---

# /xray

Execute the `xray` skill with the provided arguments.

## Instructions

**If you have a Skill tool available**: Use it directly with `skill: "xray"` instead of reading the file manually.

**Otherwise**:
1. Read the skill file at this exact path: `~/.claude/skills/xray/SKILL.md`
2. Follow all instructions in the skill file
3. Pass these arguments to the skill: `$ARGUMENTS`

**WARNING**: Do NOT use Glob, find, or search for this skill. The path above is the ONLY correct location. Other files with "xray" in the name are NOT this skill.

---
*🧬 Nat Weerawan × Oracle · Symbiotic Intelligence · v3.4.10*
*Digitized from Nat Weerawan's brain — thousands of hours working alongside AI, captured as code*
