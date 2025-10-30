---
description: Create release git commit message
---

Create an automated release commit for Python projects:

1. **Validate prerequisites:**
   - Check for staged changes (exit if none exist)
   - Verify pyproject.toml exists in repository root
   - Run in parallel: `git status`, `git diff --staged`, `git log -5`

2. **Read current version:**
   - Parse pyproject.toml to extract current version from `[project]`
   - Verify version follows semantic versioning (X.Y.Z)
   - Handle error if version is missing or invalid

3. **Determine version bump from staged changes:**
   - MAJOR (X.0.0): Breaking changes, incompatible API changes
   - MINOR (x.Y.0): New features, backward compatible
   - PATCH (x.y.Z): Bug fixes, backward compatible
   - Analyze commit messages or diff content to determine appropriate bump

4. **Calculate new version:**
   - Apply version bump rules to current version
   - Example: 1.2.3 + MINOR bump = 1.3.0

5. **Update version file:**
   - Write new version to pyproject.toml
   - Stage the modified pyproject.toml file

6. **Update CHANGELOG.md:**
   - Generate entry with new version number and date
   - Extract relevant changes from staged diff
   - Format changes as bullet points
   - Prepend to CHANGELOG.md following Keep a Changelog format
   - Stage the modified CHANGELOG.md file

7. **Create release commit:**
   - Draft commit message subject: `Release version X.Y.Z`
   - Include bullet-pointed list of changes in commit body
   - Commit all staged changes (original + version file + CHANGELOG)

8. **Create git tag:**
   - After successful commit, create annotated tag: `git tag -a vX.Y.Z -m "Release version X.Y.Z"`

Requirements:

- Focus on Python projects using pyproject.toml
- Automatically stage version file and CHANGELOG updates
- Keep commit message concise and in imperative mood
- Format CHANGELOG entries and commit message body as bullet points
- Do not push commits or tags unless explicitly asked
- If no staged changes exist, inform user and exit without committing
