# Harness Documentation System

This document describes the standardized documentation system for Harness Terraform modules, replacing external dependencies with team-controlled tooling.

## Overview

The documentation system generates README.md files from README.yaml configurations using a self-contained Python script, ensuring consistency across all Harness Terraform modules without external dependencies.

## Architecture

```
terraform-module/
├── scripts/
│   └── generate-readme.py          # Documentation generator
├── templates/
│   └── README.yaml.template        # Template for new modules
├── README.yaml                     # Documentation source
├── README.md                       # Generated documentation
└── Makefile                        # Build automation
```

## Key Benefits

### **No External Dependencies**
- ✅ Self-contained Python script (standard in CI/CD)
- ✅ No external service calls or internet requirements
- ✅ Full team control over documentation generation
- ✅ No NPM or Node.js dependencies required

### **Team Standardization**
- ✅ Consistent README.yaml structure across modules
- ✅ Standardized documentation format and styling
- ✅ Integrated with terraform-docs for technical specifications
- ✅ Template-driven approach for new modules

### **Developer Experience**
- ✅ Simple `make docs` command
- ✅ Automatic integration with existing workflows
- ✅ Clear validation and error handling
- ✅ Version control friendly (no binary dependencies)

## Usage

### For Existing Modules

1. **Copy Documentation System**:
   ```bash
   # Copy these files to your module:
   cp scripts/generate-readme.py path/to/your-module/scripts/
   cp templates/README.yaml.template path/to/your-module/templates/
   
   # Update Makefile docs target (see harness-label/Makefile for reference)
   ```

2. **Create/Update README.yaml**:
   ```bash
   # Use template as starting point
   cp templates/README.yaml.template README.yaml
   # Customize for your module
   ```

3. **Generate Documentation**:
   ```bash
   make docs          # Generate README.md
   make docs-tf       # Generate Terraform docs  
   make all           # Full validation + docs
   ```

### For New Modules

1. **Use Template**:
   ```bash
   cp templates/README.yaml.template new-module/README.yaml
   cp scripts/generate-readme.py new-module/scripts/
   ```

2. **Customize Template**:
   - Replace `MODULE_NAME_HERE` with actual module name
   - Update description, usage examples, and metadata
   - Add module-specific examples and configuration

3. **Generate Initial Documentation**:
   ```bash
   cd new-module
   make docs
   ```

## README.yaml Structure

```yaml
name: "module-name"
description: "Module description"

badges:              # Optional GitHub badges
  - name: "Badge Name"
    image: "badge-url"  
    url: "link-url"

usage:              # Code examples
  - name: "Example Name"
    description: "Example description"  
    code: |
      # HCL code here

examples:           # Link to example directories
  - name: "Example Name"
    description: "Description"
    url: "./examples/path/"

related:           # Related Harness modules
  - name: "Module Name"
    url: "github-url"
    description: "Description"

contributors:      # Team information
  - name: "Team Name"
    email: "email@harness.io"
    github: "github-username"

license: "License text"
```

## Integration with CI/CD

### GitHub Actions Example

```yaml
name: Documentation
on: [push, pull_request]

jobs:
  docs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Generate documentation
        run: make docs
      - name: Check for changes
        run: git diff --exit-code
```

### Pre-commit Hook

```bash
#!/bin/sh
# .git/hooks/pre-commit
make docs
git add README.md
```

## Generator Features

The `scripts/generate-readme.py` script provides:

- **YAML parsing** with error handling
- **Terraform-docs integration** for technical specifications  
- **Badge generation** for GitHub integrations
- **Usage example formatting** with syntax highlighting
- **Contributor tables** with GitHub avatars
- **Related projects** linking
- **License sections** with team branding

## Troubleshooting

### Common Issues

**Python not found**:
```bash
# Ensure Python 3 is available
python3 --version
# Install if needed (macOS)
brew install python3
```

**YAML parsing errors**:
```bash
# Validate YAML syntax
python3 -c "import yaml; yaml.safe_load(open('README.yaml'))"
```

**Missing terraform-docs**:
```bash
# Install terraform-docs for technical specifications
brew install terraform-docs
```

### Error Messages

- `README.yaml not found` - Create README.yaml from template
- `Documentation generator not found` - Copy generate-readme.py to scripts/
- `Error parsing YAML` - Fix YAML syntax in README.yaml

## Migration from External Tools

1. **Remove external documentation tools**:
   ```bash
   # Remove any NPM-based documentation generators
   npm uninstall -g @cloudposse/readme
   # Or other external tools that may have been used
   ```

2. **Update Makefile**:
   - Replace external tool calls with `python3 scripts/generate-readme.py`
   - Ensure Makefile includes `docs` and `docs-tf` targets

3. **Verify Harness-standard output**:
   ```bash
   make docs
   git diff README.md  # Review changes for Harness branding
   ```

## Team Standards

### Required Elements
- ✅ Module name and description
- ✅ At least one usage example
- ✅ Contributors section with team contact
- ✅ License information

### Recommended Elements  
- ✅ GitHub badges for releases and license
- ✅ Multiple usage examples (basic + advanced)
- ✅ Links to example directories
- ✅ Related Harness modules references

### Style Guidelines
- Use consistent formatting and language
- Keep descriptions concise but informative
- Include realistic, working code examples
- Use Harness branding and terminology
- Maintain professional tone throughout

This documentation system ensures all Harness Terraform modules have consistent, high-quality documentation without external dependencies.
