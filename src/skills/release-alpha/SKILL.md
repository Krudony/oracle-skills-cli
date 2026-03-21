---
name: release-alpha
description: Bump version, compile, test, commit, tag, and create GitHub alpha pre-release. Use when user says "release alpha", "alpha release", "new alpha", "tag alpha". Do NOT trigger for stable releases or version bumps without tagging.
argument-hint: "[--patch | --minor | --major]"
---

# /release-alpha — Alpha Release Pipeline

Automate the full alpha release cycle: bump → compile → test → commit → tag → release.

## Usage

```
/release-alpha              # Auto-increment alpha.N
/release-alpha --minor      # Bump minor (e.g. 3.3.0 → 3.4.0-alpha.1)
```

## Steps

### 1. Determine next version

```bash
CURRENT=$(jq -r '.version' package.json)
```

- If current is `X.Y.Z-alpha.N` → bump to `X.Y.Z-alpha.(N+1)`
- If current is `X.Y.Z` (stable) → bump to `X.Y.(Z+1)-alpha.1`
- If `--minor` → bump to `X.(Y+1).0-alpha.1`

### 2. Bump version

```bash
npm version $NEXT_VERSION --no-git-tag-version
```

### 3. Compile + test

```bash
bun run compile
bun test
```

If tests fail → STOP. Do not release.

### 4. Commit

```bash
git add package.json src/commands/ README.md
git commit -m "chore: bump $NEXT_VERSION

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>"
```

### 5. Push + tag + release

```bash
git push origin main
git tag v$NEXT_VERSION
git push origin v$NEXT_VERSION
gh release create v$NEXT_VERSION --prerelease --title "v$NEXT_VERSION" --generate-notes
```

### 6. Output

```
Released v$NEXT_VERSION
https://github.com/org/repo/releases/tag/v$NEXT_VERSION

Install:
bunx --bun oracle-skills@github:Soul-Brews-Studio/oracle-skills-cli#v$NEXT_VERSION install -g -y
```

## Safety

- NEVER release if tests fail
- NEVER release without committing first
- Always `--prerelease` flag for alpha
- Always verify `git status` is clean before starting

ARGUMENTS: $ARGUMENTS
