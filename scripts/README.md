# Scripts Documentation

This directory contains automation scripts for the Terraform module.

## Release Notes Automation

### Overview
The `generate-release-notes.sh` script automates the creation and maintenance of release notes by analyzing git commits and generating structured markdown content.

### Makefile Integration

```bash
# Generate release notes template (shows what would be added)
make release-notes

# Add new patch release section (auto-detects version)
make release-add

# Add new minor release section
VERSION_TYPE=minor make release-add

# Add new major release section
VERSION_TYPE=major make release-add

# Initialize RELEASE_NOTES.md for new projects
make release-init
```

### Direct Script Usage

```bash
# Show current changes since last tag
./scripts/generate-release-notes.sh template

# Add new release section
./scripts/generate-release-notes.sh add patch
./scripts/generate-release-notes.sh add minor
./scripts/generate-release-notes.sh add major

# Create initial release notes file
./scripts/generate-release-notes.sh init

# Show help
./scripts/generate-release-notes.sh help
```

### Features

- **Automatic Version Detection**: Reads git tags to determine current version
- **Semantic Versioning**: Supports major.minor.patch version increments
- **Commit Analysis**: Categorizes commits by type (features, fixes, docs, etc.)
- **Backup Creation**: Automatically backs up existing files before changes
- **Template Generation**: Shows what changes would be included without modifying files

### Workflow Example

1. **Make changes and commit them**
   ```bash
   git add .
   git commit -m "feat: add new VPC feature"
   ```

2. **Review pending changes**
   ```bash
   make release-notes
   ```

3. **Add release section when ready**
   ```bash
   make release-add  # for patch release
   # or
   VERSION_TYPE=minor make release-add  # for minor release
   ```

4. **Edit the generated content**
   - Review and customize the generated release notes
   - Add any missing details or context
   - Remove template sections that don't apply

5. **Commit and tag the release**
   ```bash
   git add RELEASE_NOTES.md
   git commit -m "docs: update release notes for v1.0.1"
   git tag v1.0.1
   git push origin main --tags
   ```

### Commit Message Patterns

The script recognizes these patterns when categorizing commits:

- **Features**: `feat`, `add`, `new`
- **Bug Fixes**: `fix`, `bug`, `patch`
- **Documentation**: `doc`, `readme`, `example`
- **Infrastructure**: `ci`, `build`, `deploy`, `makefile`
- **Refactoring**: `refactor`, `style`, `format`

### Customization

You can modify the categorization patterns by editing the `categorize_commits()` function in `generate-release-notes.sh`.

### Benefits

- **Consistency**: Standardized release note format across all releases
- **Automation**: Reduces manual effort in tracking changes
- **History**: Maintains complete change history in a readable format
- **Team Collaboration**: Makes it easy for team members to understand what changed
- **User Communication**: Provides clear information for module users about updates
