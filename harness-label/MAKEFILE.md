# Harness Terraform Module Makefile

This document describes the standardized Makefile for Harness Terraform modules, providing consistent development workflows and quality gates across all modules.

## Overview

The Makefile provides a standardized set of commands for:
- **Validation**: Terraform syntax and configuration validation
- **Formatting**: Consistent code formatting
- **Testing**: Comprehensive module testing
- **Documentation**: Automated documentation generation
- **Security**: Security scanning and best practices
- **Development**: Common development workflows

## Prerequisites

### Required Tools
- **terraform** - Terraform CLI (required)
- **make** - Make build tool (required)

### Optional Tools (Enhanced Features)
- **tflint** - Terraform linter for additional validation
- **tfsec** - Security scanning for Terraform code
- **terraform-docs** - Generate Terraform documentation
- **readme** - Generate README.md from README.yaml (@cloudposse/readme)

### Installation
```bash
# Install all tools (macOS with Homebrew)
make install-tools

# Manual installation
brew install terraform tflint tfsec terraform-docs
npm install -g @cloudposse/readme
```

## Usage

### Basic Commands

```bash
# Show all available commands and help
make help

# Show module information and tool status
make info
```

### Development Workflow

```bash
# Initialize Terraform (downloads providers, modules)
make init

# Format all Terraform files
make format

# Validate Terraform configuration
make validate

# Run comprehensive tests
make test

# Generate documentation
make docs

# Run pre-commit checks (format + validate + docs)
make pre-commit

# Complete validation and documentation
make all
```

### Quality Gates

```bash
# Check formatting without making changes
make format-check

# Run linting (requires tflint)
make lint

# Run security scanning (requires tfsec)
make security

# Generate Terraform documentation (requires terraform-docs)  
make docs-tf
```

### Testing and Planning

```bash
# Run Terraform plan for examples (requires credentials)
make plan

# Clean up temporary files
make clean
```

## Command Reference

| Command | Description | Dependencies |
|---------|-------------|--------------|
| `help` | Display help information | None |
| `info` | Show module and tool status | None |
| `init` | Initialize Terraform and examples | terraform |
| `validate` | Validate Terraform configuration | terraform |
| `format` | Format all Terraform files | terraform |
| `format-check` | Check formatting without changes | terraform |
| `lint` | Run Terraform linting | tflint |
| `security` | Run security scanning | tfsec |
| `docs` | Generate README.md from README.yaml | readme |
| `docs-tf` | Generate Terraform documentation | terraform-docs |
| `plan` | Run terraform plan for examples | terraform + credentials |
| `test` | Run comprehensive tests | terraform |
| `clean` | Clean temporary files | None |
| `pre-commit` | Format + validate + docs | terraform, readme |
| `all` | Complete validation + docs | All tools |
| `install-tools` | Install required tools (macOS) | brew, npm |

## Integration with CI/CD

### GitHub Actions Example

```yaml
name: Terraform Module Validation
on: [push, pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
        
      - name: Install tools
        run: |
          # Install additional tools
          curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
          curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash
          
      - name: Run validation
        run: make test
        
      - name: Generate documentation
        run: make docs
        
      - name: Check for changes
        run: git diff --exit-code
```

### GitLab CI Example

```yaml
stages:
  - validate
  - test
  - docs

terraform-validate:
  stage: validate
  image: hashicorp/terraform:latest
  script:
    - make format-check
    - make validate

terraform-test:
  stage: test
  image: hashicorp/terraform:latest
  script:
    - make test

terraform-docs:
  stage: docs
  script:
    - make docs
  artifacts:
    paths:
      - README.md
```

## File Structure

The Makefile expects the following standard Terraform module structure:

```
terraform-module/
├── Makefile              # This Makefile
├── README.yaml           # Module documentation source
├── README.md             # Generated documentation
├── *.tf                  # Terraform configuration files
├── examples/             # Usage examples
│   └── basic/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── docs/                 # Additional documentation
```

## Team Standards

### Pre-Commit Requirements

All team members should run before committing:

```bash
make pre-commit
```

This ensures:
- ✅ Consistent formatting
- ✅ Valid Terraform syntax  
- ✅ Up-to-date documentation
- ✅ No obvious configuration errors

### Code Review Checklist

- [ ] `make test` passes
- [ ] `make format-check` passes  
- [ ] Documentation is current (`make docs`)
- [ ] Examples are valid (`make plan` succeeds)
- [ ] Security scan clean (`make security`)

### Module Release Process

1. **Development**
   ```bash
   make pre-commit  # Format, validate, docs
   ```

2. **Testing**
   ```bash
   make all        # Comprehensive validation
   ```

3. **Release Preparation**
   ```bash
   make clean      # Clean temporary files
   make docs       # Ensure docs are current
   ```

## Troubleshooting

### Common Issues

**Error: "terraform not found"**
```bash
# Install Terraform
brew install terraform
# Or use tfenv for version management
brew install tfenv
tfenv install latest
```

**Error: "Module not found" during init**
```bash
# Clean and retry
make clean
make init
```

**Error: "tflint not found" warnings**
```bash
# Install tflint for enhanced validation
brew install tflint
```

**Documentation not generating**
```bash
# Install readme tool
npm install -g @cloudposse/readme

# Verify README.yaml exists and is valid
cat README.yaml
```

### Debug Mode

Add `VERBOSE=1` to any command for detailed output:

```bash
VERBOSE=1 make validate
```

## Customization

### Module-Specific Customization

Create a `Makefile.local` file for module-specific overrides:

```makefile
# Makefile.local - module-specific customization

# Override default behavior
custom-test:
	@echo "Running custom tests..."
	# Add module-specific test logic

# Include the standard Makefile
include Makefile
```

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `VERBOSE` | Enable verbose output | unset |
| `TF_VAR_*` | Terraform variables | N/A |
| `AWS_*` | AWS credentials for planning | N/A |

## Support

- **Issues**: Report issues with the Makefile in the team Slack channel
- **Improvements**: Submit PRs for Makefile enhancements
- **Questions**: Reach out to the DevOps team for guidance

This Makefile is designed to be copied to all Harness Terraform modules to ensure consistency across the organization.
