---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*)
description: Commit staged changes with a descriptive message
---

Commit the currently staged changes:

1. Run in parallel: `git status`, `git diff --staged`, and `git log --oneline -10`
2. Draft a commit message following Conventional Commits specification
3. Run `git status` to verify

Requirements:

- Follow Conventional Commits format: `<type>[optional scope]: <description>`
- Use appropriate commit types:
  - `feat`: new feature
  - `fix`: bug fix
  - `docs`: documentation changes
  - `style`: formatting, missing semicolons, etc.
  - `refactor`: code restructuring without changing behavior
  - `perf`: performance improvements
  - `test`: adding or updating tests
  - `build`: build system or dependencies
  - `ci`: CI configuration changes
  - `chore`: other changes that don't modify src or test files
- Keep description concise and in imperative mood
- Match repository's existing commit style when possible
- Only commit staged changes (do not stage new files)
- Do not push unless asked
- If no staged changes, inform user and skip commit
