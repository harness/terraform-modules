# New Terraform Module Setup Guide

This guide explains how to copy the standardized development and documentation system from harness-label to a new Terraform module.

## Quick Start

Copy these **6 essential files** from harness-label to your new module:

```bash
# Navigate to your new module directory
cd /path/to/your-new-module

# Copy required files from harness-label
cp /path/to/harness-label/Makefile .
cp /path/to/harness-label/.gitignore .
cp -r /path/to/harness-label/scripts .
cp -r /path/to/harness-label/templates .
cp /path/to/harness-label/MAKEFILE.md .
cp /path/to/harness-label/DOCUMENTATION.md .
```

## File-by-File Setup

### 1. Makefile ✅ **REQUIRED**
**Source**: `Makefile`  
**Purpose**: Standardized build automation with validation, formatting, documentation generation

```bash
cp /path/to/harness-label/Makefile .
```

**No customization needed** - Works for any Terraform module

### 2. Git Ignore File ✅ **REQUIRED**
**Source**: `.gitignore`  
**Purpose**: Excludes Terraform providers, state files, and OS artifacts from git tracking

```bash
cp /path/to/harness-label/.gitignore .
```

**No customization needed** - Prevents large Terraform provider binaries and temporary files from being committed

### 3. Documentation Generator ✅ **REQUIRED**
**Source**: `scripts/generate-readme.py`  
**Purpose**: Self-contained README.md generator (no external dependencies)

```bash
mkdir -p scripts
cp /path/to/harness-label/scripts/generate-readme.py scripts/
```

**No customization needed** - Universal documentation generator

### 4. Documentation Template ✅ **REQUIRED**
**Source**: `templates/README.yaml.template`  
**Purpose**: Template for creating module documentation

```bash
mkdir -p templates
cp /path/to/harness-label/templates/README.yaml.template templates/
```

**Customization required** - See [Step-by-Step Customization](#step-by-step-customization)

### 5. Makefile Documentation 📖 **RECOMMENDED**
**Source**: `MAKEFILE.md`  
**Purpose**: Team guide for using Makefile commands

```bash
cp /path/to/harness-label/MAKEFILE.md .
```

**No customization needed** - Universal Makefile documentation

### 6. Documentation System Guide 📖 **RECOMMENDED**
**Source**: `DOCUMENTATION.md`  
**Purpose**: Complete guide to the documentation system

```bash
cp /path/to/harness-label/DOCUMENTATION.md .
```

**No customization needed** - Universal system documentation

## Step-by-Step Customization

### Step 1: Create Your README.yaml

```bash
# Use template as starting point
cp templates/README.yaml.template README.yaml
```

### Step 2: Customize README.yaml

Edit `README.yaml` with your module details:

```yaml
# Replace these placeholders:
name: "your-module-name"                    # ← Your module name
description: "What your module does"        # ← Your module description

# Update GitHub URLs:
badges:
  - name: "Latest Release"
    image: "https://img.shields.io/github/release/harness/terraform-YOUR-MODULE.svg"
    url: "https://github.com/harness/terraform-YOUR-MODULE/releases/latest"

# Add your usage examples:
usage:
  - name: "Basic Usage" 
    description: "Simple example"
    code: |
      module "example" {
        source = "git::https://github.com/harness/terraform-YOUR-MODULE.git?ref=main"
        
        # Your module variables here
        name = "example"
      }

# Update contributors:
contributors:
  - name: "Your Name"
    email: "your.email@harness.io"
    github: "your-github-username"
```

### Step 3: Generate Initial Documentation

```bash
make docs
```

This creates `README.md` from your `README.yaml`.

### Step 4: Validate Setup

```bash
make help    # Show available commands
make info    # Check tool status
make test    # Run validation
```

## Directory Structure

After setup, your module should have:

```
your-terraform-module/
├── scripts/
│   └── generate-readme.py          # ✅ Documentation generator
├── templates/
│   └── README.yaml.template        # 📝 Template for future use
├── examples/                       # Your module examples
│   └── basic/
├── .gitignore                      # ✅ Git exclusions for Terraform
├── Makefile                        # ✅ Build automation  
├── MAKEFILE.md                     # 📖 Makefile documentation
├── DOCUMENTATION.md                # 📖 Documentation system guide
├── README.yaml                     # 📝 Your module documentation source
├── README.md                       # 📄 Generated documentation
├── main.tf                         # Your Terraform code
├── variables.tf                    # Your Terraform variables
├── outputs.tf                      # Your Terraform outputs
└── versions.tf                     # Terraform version constraints
```

## Available Commands

Once setup is complete, you have access to:

```bash
# Documentation
make docs          # Generate README.md from README.yaml
make docs-tf       # Generate Terraform technical docs

# Validation  
make validate      # Validate Terraform syntax
make format        # Format Terraform files
make test          # Run comprehensive tests

# Workflows
make pre-commit    # Format + validate + docs  
make all           # Complete validation + documentation

# Utilities
make clean         # Clean temporary files
make help          # Show all commands
make info          # Module and tool status
```

## Common Customizations

### Adding Module-Specific Make Targets

Add to your `Makefile`:

```makefile
# Add after the existing targets

## Run module-specific tests
test-custom:
	@printf "\033[0;34mRunning custom tests...\033[0m\n"
	# Add your custom test commands
	@printf "\033[0;32m✓ Custom tests passed\033[0m\n"
```

### Custom Documentation Sections

Edit your `README.yaml` to add module-specific sections:

```yaml
# Add advanced examples
usage:
  - name: "Advanced Configuration"
    description: "Complex usage example" 
    code: |
      module "advanced" {
        # Advanced configuration here
      }

# Add related modules
related:
  - name: "harness-label"
    url: "https://github.com/harness/terraform-harness-label"
    description: "Terraform labeling module"
```

## Troubleshooting

### Setup Issues

**"make: command not found"**
```bash
# macOS
xcode-select --install

# Linux
sudo apt-get install build-essential
```

**"python3: command not found"**
```bash
# macOS  
brew install python3

# Linux
sudo apt-get install python3
```

### Validation Issues

**Terraform validation fails**
```bash
# Check Terraform syntax
terraform validate

# Format files
make format
```

**Documentation generation fails**
```bash
# Check YAML syntax
python3 -c "import yaml; yaml.safe_load(open('README.yaml'))"

# Verify script permissions
chmod +x scripts/generate-readme.py
```

## Team Integration

### Repository Setup

1. **Copy files** using this guide
2. **Customize README.yaml** with your module details  
3. **Run initial validation**: `make all`
4. **Commit to repository**:
   ```bash
   git add Makefile scripts/ templates/ *.md README.yaml README.md
   git commit -m "Add standardized development and documentation system"
   ```

### CI/CD Integration

Add to your `.github/workflows/validate.yml`:

```yaml
name: Terraform Validation
on: [push, pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
      - name: Run validation
        run: make test
      - name: Generate docs  
        run: make docs
      - name: Check for changes
        run: git diff --exit-code
```

## Support

- **Questions**: Reach out to the DevOps team
- **Issues**: Reference this guide and MAKEFILE.md
- **Updates**: Check harness-label repository for system updates

---

**Summary**: Copy 5 files, customize README.yaml, run `make docs`. Your new module will have the same professional development and documentation system as harness-label.
