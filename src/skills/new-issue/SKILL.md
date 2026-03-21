---
name: new-issue
description: Create a GitHub issue in the current repo. Use when user says "new issue", "create issue", "open issue", "file bug", "feature request". Do NOT trigger for viewing issues (use gh issue list) or working on issues (use /workon).
argument-hint: "<title> [--body <text>] [--label <label>]"
---

# /new-issue — Create GitHub Issue

Quick issue creation in the current repo.

## Usage

```
/new-issue Fix login redirect bug
/new-issue "Add dark mode" --label enhancement
/new-issue --body "Detailed description here"
```

## Steps

1. Parse title from arguments
2. If no title provided, ask user
3. Create issue:

```bash
gh issue create --title "$TITLE" $EXTRA_FLAGS
```

4. Show result: issue URL + number

## Auto-detect

- If in a worktree, create issue in the **parent repo** (not the worktree)
- If `--label` not provided, skip labels
- If `--body` not provided, generate a brief body from context

## Output

```
Created #N: <title>
https://github.com/org/repo/issues/N
```

ARGUMENTS: $ARGUMENTS
