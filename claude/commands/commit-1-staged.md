---
description: Commit staged changes with a descriptive message
---

Commit the currently staged changes:

1. Check for staged changes with `git diff --cached` - skip if none exist
2. Review changes: `git status` and `git diff --staged`
3. Create commit with descriptive message using heredoc format
4. Verify with `git status`

Requirements:

- Use imperative mood (e.g., "add feature" not "added feature")
- For complex changes, include bulleted body after blank line:

  ```
  add user authentication system

  - Implement JWT token generation
  - Add login and registration endpoints
  - Create user model and migrations
  ```

- Only commit staged files (don't stage additional files)
- Don't push unless explicitly requested
