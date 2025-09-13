# Harness OpenTofu Module Makefile
# Standardized build and validation tools for OpenTofu modules
# Version: 1.1.0

SHELL := /bin/bash
.DEFAULT_GOAL := help
.PHONY: help init validate format lint security test docs clean all pre-commit pre-commit-legacy pre-commit-install pre-commit-all pre-commit-update pre-commit-clean release-notes pre-release-check release-add release-init release release-automated release-help update-from-template template-list template-add template-remove template-update-all template-update template-update-dry-run template-help

# Module information
MODULE_NAME := $(shell basename $(CURDIR))
TOFU_VERSION := $(shell tofu version -json 2>/dev/null | jq -r '.terraform_version' 2>/dev/null || echo "unknown")

## Display help information
help:
	@printf "\033[0;34mHarness OpenTofu Module: $(MODULE_NAME)\033[0m\n"
	@printf "\033[0;34mOpenTofu Version: $(TOFU_VERSION)\033[0m\n\n"
	@printf "\033[0;33mAvailable targets:\033[0m\n"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[0;32m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@printf "\n\033[0;33mCommon workflows:\033[0m\n"
	@printf "  \033[0;32mmake all\033[0m        - Full validation and documentation generation\n"
	@printf "  \033[0;32mmake pre-commit\033[0m - Run pre-commit checks (format, validate, docs)\n"
	@printf "  \033[0;32mmake test\033[0m       - Run all tests and validations\n"
	@printf "  \033[0;32mmake update-from-template\033[0m - Sync latest changes from terraform-module-template\n"
	@printf "  \033[0;32mVALIDATE_EXAMPLES=true make validate\033[0m - Include example validation\n"

## Initialize OpenTofu and install dependencies
init:
	@printf "\033[0;34mInitializing OpenTofu...\033[0m\n"
	@tofu init -upgrade
	@if [ -d "examples" ]; then \
		for example in examples/*/; do \
			if [ -f "$$example/main.tf" ]; then \
				printf "\033[0;34mInitializing example: $$example\033[0m\n"; \
				(cd "$$example" && tofu init -upgrade); \
			fi; \
		done; \
	fi

## Validate OpenTofu configuration
validate: init
	@printf "\033[0;34mValidating OpenTofu configuration...\033[0m\n"
	@tofu validate
	@if [ -d "examples" ] && [ "$${VALIDATE_EXAMPLES}" = "true" ]; then \
		for example in examples/*/; do \
			if [ -f "$$example/main.tf" ]; then \
				printf "\033[0;34mValidating example: $$example\033[0m\n"; \
				(cd "$$example" && tofu validate); \
			fi; \
		done; \
	elif [ -d "examples" ]; then \
		example_count=$$(find examples -maxdepth 1 -type d | grep -v '^examples$$' | wc -l | tr -d ' '); \
		printf "\033[0;33m⚠ Skipping $$example_count examples (set VALIDATE_EXAMPLES=true for full validation)\033[0m\n"; \
	fi
	@printf "\033[0;32m✓ OpenTofu validation passed\033[0m\n"


## Format OpenTofu files
format:
	@printf "\033[0;34mFormatting OpenTofu files...\033[0m\n"
	@tofu fmt -recursive -diff
	@printf "\033[0;32m✓ OpenTofu formatting complete\033[0m\n"

## Check OpenTofu formatting without making changes
format-check:
	@printf "\033[0;34mChecking OpenTofu formatting...\033[0m\n"
	@if ! tofu fmt -recursive -check -diff; then \
		printf "\033[0;31m✗ OpenTofu files need formatting. Run 'make format' to fix.\033[0m\n"; \
		exit 1; \
	fi
	@printf "\033[0;32m✓ OpenTofu formatting is correct\033[0m\n"

## Run linting with tflint (if available)
lint:
	@printf "\033[0;34mRunning OpenTofu linting...\033[0m\n"
	@if command -v tflint >/dev/null 2>&1; then \
		tflint --init; \
		tflint; \
		printf "\033[0;32m✓ Linting passed\033[0m\n"; \
	else \
		printf "\033[0;33m⚠ tflint not installed. Skipping linting.\033[0m\n"; \
		printf "\033[0;33m  Install with: brew install tflint\033[0m\n"; \
	fi

## Run security scanning with tfsec (if available)
security:
	@printf "\033[0;34mRunning security scanning...\033[0m\n"
	@if command -v tfsec >/dev/null 2>&1; then \
		tfsec .; \
		printf "\033[0;32m✓ Security scan completed\033[0m\n"; \
	else \
		printf "\033[0;33m⚠ tfsec not installed. Skipping security scan.\033[0m\n"; \
		printf "\033[0;33m  Install with: brew install tfsec\033[0m\n"; \
	fi

## Generate README.md from README.yaml
docs:
	@printf "\033[0;34mGenerating documentation...\033[0m\n"
	@if [ -f "README.yaml" ]; then \
		if [ -f "scripts/generate-readme.sh" ]; then \
			./scripts/generate-readme.sh; \
			printf "\033[0;32m✓ README.md generated from README.yaml\033[0m\n"; \
		else \
			printf "\033[0;31m✗ Documentation generator not found at scripts/generate-readme.sh\033[0m\n"; \
			exit 1; \
		fi; \
	else \
		printf "\033[0;33m⚠ README.yaml not found. Skipping documentation generation.\033[0m\n"; \
	fi

## Generate OpenTofu documentation with terraform-docs (if available)
docs-tf:
	@printf "\033[0;34mGenerating OpenTofu documentation...\033[0m\n"
	@if command -v terraform-docs >/dev/null 2>&1; then \
		terraform-docs markdown table --output-file OPENTOFU.md .; \
		printf "\033[0;32m✓ OPENTOFU.md generated\033[0m\n"; \
	else \
		printf "\033[0;33m⚠ terraform-docs not installed. Skipping OpenTofu docs.\033[0m\n"; \
		printf "\033[0;33m  Install with: brew install terraform-docs\033[0m\n"; \
	fi

## Run OpenTofu plan for examples (requires AWS credentials)
plan:
	@printf "\033[0;34mRunning OpenTofu plan for examples...\033[0m\n"
	@if [ -d "examples" ]; then \
		for example in examples/*/; do \
			if [ -f "$$example/main.tf" ]; then \
				printf "\033[0;34mPlanning example: $$example\033[0m\n"; \
				(cd "$$example" && tofu plan -out=tfplan); \
			fi; \
		done; \
	else \
		printf "\033[0;33m⚠ No examples directory found\033[0m\n"; \
	fi

## Run comprehensive tests
test: validate format-check lint security
	@printf "\033[0;32m✓ All tests passed\033[0m\n"

## Clean up temporary files and caches
clean:
	@printf "\033[0;34mCleaning up temporary files...\033[0m\n"
	@find . -type f -name "*.tfplan" -delete
	@find . -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null || true
	@find . -type f -name ".terraform.lock.hcl" -delete 2>/dev/null || true
	@find . -type f -name "terraform.tfstate*" -delete 2>/dev/null || true
	@find . -type f -name "tofu.tfstate*" -delete 2>/dev/null || true
	@printf "\033[0;32m✓ Cleanup complete\033[0m\n"

## Run legacy pre-commit checks (formatting, validation, documentation)
pre-commit-legacy: format validate docs
	@printf "\033[0;32m✓ Legacy pre-commit checks completed\033[0m\n"

## Install pre-commit framework and hooks
pre-commit-install: ## Install pre-commit hooks for automated code quality checks
	@printf "\033[0;34mInstalling pre-commit framework and hooks...\033[0m\n"
	@if command -v pre-commit >/dev/null 2>&1; then \
		pre-commit install; \
		pre-commit install --hook-type commit-msg; \
		printf "\033[0;32m✓ Pre-commit hooks installed\033[0m\n"; \
	else \
		printf "\033[0;31m✗ pre-commit not found. Install with: pip install pre-commit\033[0m\n"; \
		printf "\033[0;33m  Or with Homebrew: brew install pre-commit\033[0m\n"; \
		exit 1; \
	fi

## Run all pre-commit hooks on all files
pre-commit-all: ## Run all pre-commit hooks on all files (bypass git staging)
	@printf "\033[0;34mRunning all pre-commit hooks on all files...\033[0m\n"
	@if command -v pre-commit >/dev/null 2>&1; then \
		pre-commit run --all-files; \
		printf "\033[0;32m✓ Pre-commit checks completed\033[0m\n"; \
	else \
		printf "\033[0;31m✗ pre-commit not found. Run 'make pre-commit-install' first\033[0m\n"; \
		exit 1; \
	fi

## Run pre-commit hooks on staged files only
pre-commit: ## Run pre-commit hooks on staged files (normal git workflow)
	@printf "\033[0;34mRunning pre-commit hooks on staged files...\033[0m\n"
	@if command -v pre-commit >/dev/null 2>&1; then \
		pre-commit run; \
		printf "\033[0;32m✓ Pre-commit checks completed\033[0m\n"; \
	else \
		printf "\033[0;31m✗ pre-commit not found. Run 'make pre-commit-install' first\033[0m\n"; \
		exit 1; \
	fi

## Update pre-commit hooks to latest versions
pre-commit-update: ## Update all pre-commit hooks to their latest versions
	@printf "\033[0;34mUpdating pre-commit hooks...\033[0m\n"
	@if command -v pre-commit >/dev/null 2>&1; then \
		pre-commit autoupdate; \
		printf "\033[0;32m✓ Pre-commit hooks updated\033[0m\n"; \
	else \
		printf "\033[0;31m✗ pre-commit not found. Run 'make pre-commit-install' first\033[0m\n"; \
		exit 1; \
	fi

## Clean pre-commit cache and reinstall hooks
pre-commit-clean: ## Clean pre-commit cache and reinstall hooks
	@printf "\033[0;34mCleaning pre-commit cache...\033[0m\n"
	@if command -v pre-commit >/dev/null 2>&1; then \
		pre-commit clean; \
		pre-commit install --install-hooks; \
		printf "\033[0;32m✓ Pre-commit cache cleaned and hooks reinstalled\033[0m\n"; \
	else \
		printf "\033[0;31m✗ pre-commit not found. Run 'make pre-commit-install' first\033[0m\n"; \
		exit 1; \
	fi

## Run full validation and documentation generation
all: clean init format validate lint security docs docs-tf
	@printf "\033[0;32m✓ Complete module validation and documentation generation finished\033[0m\n"

## Install required tools (macOS with Homebrew)
install-tools:
	@printf "\033[0;34mInstalling required tools...\033[0m\n"
	@if command -v brew >/dev/null 2>&1; then \
		brew install opentofu tflint tfsec trivy terraform-docs pre-commit checkov yq yamlfmt; \
		printf "\033[0;32m✓ Core tools installed\033[0m\n"; \
		printf "\033[0;34mInstalling pre-commit hooks...\033[0m\n"; \
		$(MAKE) pre-commit-install; \
	else \
		printf "\033[0;31m✗ Homebrew not found. Please install tools manually:\033[0m\n"; \
		echo "  - opentofu: https://opentofu.org/docs/intro/install/"; \
		echo "  - tflint: https://github.com/terraform-linters/tflint"; \
		echo "  - tfsec: https://github.com/aquasecurity/tfsec"; \
		echo "  - terraform-docs: https://github.com/terraform-docs/terraform-docs"; \
		echo "  - pre-commit: https://pre-commit.com/#install"; \
		echo "  - checkov: pip install checkov"; \
		echo "  - yq: https://github.com/mikefarah/yq"; \
		echo "  - trivy: https://github.com/aquasecurity/trivy"; \
		echo "  - yamlfmt: https://github.com/google/yamlfmt"; \
	fi

## Show module information and status
info:
	@printf "\033[0;34mModule Information:\033[0m\n"
	@echo "  Name: $(MODULE_NAME)"
	@echo "  Path: $(CURDIR)"
	@echo "  OpenTofu Version: $(TOFU_VERSION)"
	@echo ""
	@printf "\033[0;34mFile Status:\033[0m\n"
	@echo "  OpenTofu files: $$(find . -name '*.tf' | wc -l | tr -d ' ')"
	@echo "  Example directories: $$(find examples -maxdepth 1 -type d 2>/dev/null | grep -v '^examples$$' | wc -l | tr -d ' ' || echo '0')"
	@echo "  Documentation files: $$(ls -1 *.md 2>/dev/null | wc -l | tr -d ' ')"
	@echo ""
	@printf "\033[0;34mTool Status:\033[0m\n"
	@command -v tofu >/dev/null 2>&1 && echo "  ✓ tofu" || echo "  ✗ tofu"
	@command -v tflint >/dev/null 2>&1 && echo "  ✓ tflint" || echo "  ✗ tflint"
	@command -v tfsec >/dev/null 2>&1 && echo "  ✓ tfsec" || echo "  ✗ tfsec"
	@command -v terraform-docs >/dev/null 2>&1 && echo "  ✓ terraform-docs" || echo "  ✗ terraform-docs"

## Force update from terraform-module-template repository
update-from-template: ## Pull latest changes from terraform-module-template and sync to current module
	@printf "\033[0;34mForce updating from terraform-module-template repository...\033[0m\n"
	@if [ ! -d "/tmp/terraform-module-template-sync" ]; then \
		printf "\033[0;34mCloning terraform-module-template repository...\033[0m\n"; \
		git clone https://github.com/harness/terraform-module-template.git /tmp/terraform-module-template-sync; \
	else \
		printf "\033[0;34mUpdating existing terraform-module-template clone...\033[0m\n"; \
		cd /tmp/terraform-module-template-sync && git fetch origin && git reset --hard origin/main; \
	fi
	@printf "\033[0;34mSyncing template files to current module...\033[0m\n"
	@cd /tmp/terraform-module-template-sync && ./update-module.sh --all $(CURDIR)
	@printf "\033[0;32m✓ Template sync completed. Review changes with 'git diff'\033[0m\n"

## ========================================================================
## 🏗 TEMPLATE MANAGEMENT SYSTEM (Template Repository Only)
## ========================================================================

## List all tracked repositories
template-list: ## Show all repositories being tracked by the template management system
	@if [ -f ".template-management/manage-repositories.sh" ]; then \
		./.template-management/manage-repositories.sh list; \
	else \
		printf "\033[0;31m✗ Template management system not available (only in template repository)\033[0m\n"; \
	fi

## Add repository to tracking system
template-add: ## Add repository to template tracking (usage: make template-add REPO=name URL=git-url)
	@if [ -f ".template-management/manage-repositories.sh" ]; then \
		if [ -z "$(REPO)" ] || [ -z "$(URL)" ]; then \
			printf "\033[0;31m✗ Usage: make template-add REPO=terraform-aws-example URL=https://git.../terraform-aws-example.git\033[0m\n"; \
			printf "\033[0;33m  Optional: BRANCH=main CONTACT=team@harness.io AUTO=true\033[0m\n"; \
			exit 1; \
		fi; \
		./.template-management/manage-repositories.sh add "$(REPO)" "$(URL)" "$(or $(BRANCH),main)" "$(or $(CONTACT),platform-team@harness.io)" "$(or $(AUTO),true)"; \
	else \
		printf "\033[0;31m✗ Template management system not available (only in template repository)\033[0m\n"; \
	fi

## Remove repository from tracking system
template-remove: ## Remove repository from template tracking (usage: make template-remove REPO=name)
	@if [ -f ".template-management/manage-repositories.sh" ]; then \
		if [ -z "$(REPO)" ]; then \
			printf "\033[0;31m✗ Usage: make template-remove REPO=terraform-aws-example\033[0m\n"; \
			exit 1; \
		fi; \
		./.template-management/manage-repositories.sh remove "$(REPO)"; \
	else \
		printf "\033[0;31m✗ Template management system not available (only in template repository)\033[0m\n"; \
	fi

## Update all tracked repositories with latest template
template-update-all: ## Update all tracked repositories with latest template changes
	@if [ -f ".template-management/update-tracked-modules.sh" ]; then \
		printf "\033[0;35m🚀 Updating all tracked repositories with template changes...\033[0m\n"; \
		./.template-management/update-tracked-modules.sh; \
	else \
		printf "\033[0;31m✗ Template management system not available (only in template repository)\033[0m\n"; \
	fi

## Update specific repository with latest template
template-update: ## Update specific repository (usage: make template-update REPO=name)
	@if [ -f ".template-management/update-tracked-modules.sh" ]; then \
		if [ -z "$(REPO)" ]; then \
			printf "\033[0;31m✗ Usage: make template-update REPO=terraform-aws-example\033[0m\n"; \
			exit 1; \
		fi; \
		printf "\033[0;35m🚀 Updating $(REPO) with template changes...\033[0m\n"; \
		./.template-management/update-tracked-modules.sh --repo "$(REPO)"; \
	else \
		printf "\033[0;31m✗ Template management system not available (only in template repository)\033[0m\n"; \
	fi

## Preview template updates without making changes
template-update-dry-run: ## Preview what would be updated without making changes
	@if [ -f ".template-management/update-tracked-modules.sh" ]; then \
		printf "\033[0;35m🔍 Previewing template updates (dry run)...\033[0m\n"; \
		./.template-management/update-tracked-modules.sh --dry-run; \
	else \
		printf "\033[0;31m✗ Template management system not available (only in template repository)\033[0m\n"; \
	fi

## Show template management help
template-help: ## Show template management system help and usage
	@printf "\033[0;35m📋 Template Management System\033[0m\n"
	@printf "\033[0;34mManage downstream repositories that use this template\033[0m\n\n"
	@printf "\033[0;33mRepository Management:\033[0m\n"
	@printf "  make template-list                                    # List tracked repositories\n"
	@printf "  make template-add REPO=name URL=git-url              # Add repository\n"
	@printf "  make template-remove REPO=name                       # Remove repository\n"
	@printf "\n\033[0;33mTemplate Updates:\033[0m\n"
	@printf "  make template-update-all                             # Update all repositories\n"
	@printf "  make template-update REPO=name                       # Update specific repository\n"
	@printf "  make template-update-dry-run                         # Preview updates\n"
	@printf "\n\033[0;33mExamples:\033[0m\n"
	@printf "  make template-add REPO=terraform-aws-s3 URL=https://git0.harness.io/.../terraform-aws-s3.git\n"
	@printf "  make template-update REPO=terraform-aws-s3\n"
	@printf "  make template-remove REPO=terraform-aws-old\n"
	@printf "\n\033[0;33mNote:\033[0m Template management system is only available in the template repository\n"

## Generate or update release notes
release-notes: ## Generate release notes template or update existing notes
	@printf "\033[0;34mGenerating release notes...\033[0m\n"
	@./scripts/generate-release-notes.sh template
	@printf "\033[0;32m✓ Release notes generation complete\033[0m\n"

## Pre-release validation and documentation update
pre-release-check: ## Validate and update all documentation before release
	@printf "\033[0;34mChecking git status...\033[0m\n"
	@if [ -n "$$(git status --porcelain)" ]; then \
		printf "\033[0;31m✗ Working directory is not clean. Please commit or stash changes first.\033[0m\n"; \
		git status --short; \
		exit 1; \
	fi
	@printf "\033[0;32m✓ Working directory is clean\033[0m\n"
	@printf "\033[0;34mRunning validation checks...\033[0m\n"
	@if [ -f "main.tf" ] && ! grep -q "{{" main.tf; then \
		$(MAKE) validate > /dev/null 2>&1 || (printf "\033[0;31m✗ OpenTofu validation failed\033[0m\n"; exit 1); \
		printf "\033[0;32m✓ OpenTofu validation passed\033[0m\n"; \
	else \
		printf "\033[0;33m⚠ Skipping OpenTofu validation (template or no main.tf found)\033[0m\n"; \
	fi
	@printf "\033[0;34mChecking formatting...\033[0m\n"
	@if [ -f "main.tf" ] && ! grep -q "{{" main.tf; then \
		$(MAKE) format-check > /dev/null 2>&1 || (printf "\033[0;31m✗ Code formatting check failed\033[0m\n"; exit 1); \
		printf "\033[0;32m✓ Code formatting is correct\033[0m\n"; \
	else \
		printf "\033[0;33m⚠ Skipping format check (template or no main.tf found)\033[0m\n"; \
	fi
	@printf "\033[0;34mUpdating documentation...\033[0m\n"
	@if [ -f "README.yaml" ]; then \
		$(MAKE) docs > /dev/null 2>&1 && printf "\033[0;32m✓ README.md updated from README.yaml\033[0m\n" || printf "\033[0;33m⚠ Could not update README.md from README.yaml\033[0m\n"; \
	else \
		printf "\033[0;33m⚠ No README.yaml found, skipping README generation\033[0m\n"; \
	fi
	@$(MAKE) docs-tf > /dev/null 2>&1 && printf "\033[0;32m✓ OpenTofu documentation updated\033[0m\n" || printf "\033[0;33m⚠ Could not update OpenTofu documentation\033[0m\n"
	@printf "\033[0;34mChecking for documentation changes...\033[0m\n"
	@if [ -n "$$(git status --porcelain)" ]; then \
		printf "\033[0;33m📝 Documentation has been updated. Please review and commit changes:\033[0m\n"; \
		git status --short; \
		printf "\033[0;33mCommit these changes? (y/n): \033[0m"; \
		read -r answer; \
		if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
			git add README.md OPENTOFU.md 2>/dev/null || true; \
			git commit -m "docs: update documentation before release"; \
			printf "\033[0;32m✓ Documentation changes committed\033[0m\n"; \
		else \
			printf "\033[0;31m✗ Please commit documentation changes before proceeding\033[0m\n"; \
			exit 1; \
		fi; \
	else \
		printf "\033[0;32m✓ Documentation is up to date\033[0m\n"; \
	fi


## Add new release section to RELEASE_NOTES.md
release-add: ## Add new patch release section (use VERSION_TYPE=minor|major for other types)
	@printf "\033[0;34mAdding new release section...\033[0m\n"
	@./scripts/generate-release-notes.sh add $(VERSION_TYPE)
	@printf "\033[0;32m✓ New release section added\033[0m\n"

## Initialize RELEASE_NOTES.md file
release-init: ## Create initial RELEASE_NOTES.md file
	@printf "\033[0;34mInitializing release notes...\033[0m\n"
	@./scripts/generate-release-notes.sh init
	@printf "\033[0;32m✓ Release notes initialized\033[0m\n"

## Complete interactive release process (default for human users)
release: ## Create a complete release with interactive prompts (patch by default, use VERSION_TYPE=minor|major)
	@printf "\033[0;35m🚀 Starting interactive release process...\033[0m\n"
	@printf "\033[0;34mRunning pre-release validation...\033[0m\n"
	@$(MAKE) pre-release-check
	@$(MAKE) release-add VERSION_TYPE=$(or $(VERSION_TYPE),patch)
	@printf "\033[0;33m📝 Please review and edit RELEASE_NOTES.md, then press Enter to continue...\033[0m\n"
	@read -p ""
	@printf "\033[0;34mCommitting release notes...\033[0m\n"
	@git add RELEASE_NOTES.md
	@NEXT_VERSION=$$(./scripts/generate-release-notes.sh get-next-version $(or $(VERSION_TYPE),patch) 2>/dev/null || echo "v1.0.0"); \
	git commit -m "docs: add $$NEXT_VERSION release notes - $(or $(RELEASE_DESC),interactive release)" && \
	printf "\033[0;34mCreating release tag $$NEXT_VERSION...\033[0m\n" && \
	git tag -a $$NEXT_VERSION -m "Release $$NEXT_VERSION: $(or $(RELEASE_DESC),Interactive release)" && \
	printf "\033[0;34mPushing to remote repository...\033[0m\n" && \
	git push origin main && \
	git push origin $$NEXT_VERSION && \
	printf "\033[0;32m✅ Release $$NEXT_VERSION completed successfully!\033[0m\n"

## Automated release process (for Claude/CI use)
release-automated: ## Create a complete automated release without prompts (patch by default, use VERSION_TYPE=minor|major)
	@printf "\033[0;35m🚀 Starting automated release process...\033[0m\n"
	@printf "\033[0;34mRunning pre-release validation...\033[0m\n"
	@$(MAKE) pre-release-check
	@AUTOMATED_RELEASE=true $(MAKE) release-add VERSION_TYPE=$(or $(VERSION_TYPE),patch)
	@printf "\033[0;34mCommitting release notes...\033[0m\n"
	@git add RELEASE_NOTES.md
	@NEXT_VERSION=$$(./scripts/generate-release-notes.sh get-next-version $(or $(VERSION_TYPE),patch) 2>/dev/null || echo "v1.0.0"); \
	git commit -m "docs: add $$NEXT_VERSION release notes - $(or $(RELEASE_DESC),automated release)" && \
	printf "\033[0;34mCreating release tag $$NEXT_VERSION...\033[0m\n" && \
	git tag -a $$NEXT_VERSION -m "Release $$NEXT_VERSION: $(or $(RELEASE_DESC),Automated release)$$(echo -e '\n\n🤖 Generated with [Claude Code](https://claude.ai/code)')" && \
	printf "\033[0;34mPushing to remote repository...\033[0m\n" && \
	git push origin main && \
	git push origin $$NEXT_VERSION && \
	printf "\033[0;32m✅ Release $$NEXT_VERSION completed successfully!\033[0m\n"


## Show complete release workflow help
release-help: ## Show step-by-step release workflow
	@printf "\033[0;35m📋 Complete Release Workflow:\033[0m\n"
	@printf "\033[0;34mInteractive (Default - Recommended for Manual Use):\033[0m\n"
	@printf "  make release                    # Create patch release with prompts\n"
	@printf "  make release VERSION_TYPE=minor # Create minor release with prompts\n"
	@printf "  make release VERSION_TYPE=major # Create major release with prompts\n"
	@printf "\n\033[0;34mAutomated (For Claude/CI):\033[0m\n"
	@printf "  make release-automated                    # Create patch release (no prompts)\n"
	@printf "  make release-automated VERSION_TYPE=minor # Create minor release (no prompts)\n"
	@printf "  make release-automated VERSION_TYPE=major # Create major release (no prompts)\n"
	@printf "  RELEASE_DESC=\"description\" make release-automated # Add custom description\n"
	@printf "\n\033[0;34mManual Steps:\033[0m\n"
	@printf "  1. make release-add [VERSION_TYPE=patch|minor|major]\n"
	@printf "  2. Edit RELEASE_NOTES.md to review/customize content\n"
	@printf "  3. git add RELEASE_NOTES.md && git commit -m 'docs: add vX.Y.Z release notes'\n"
	@printf "  4. git tag -a vX.Y.Z -m 'Release vX.Y.Z: description'\n"
	@printf "  5. git push origin main && git push origin vX.Y.Z\n"
	@printf "\n\033[0;34mValidation Commands:\033[0m\n"
	@printf "  make pre-release-check          # Validate code, update docs, check git status\n"
	@printf "  make release-notes              # Preview changes since last tag\n"
	@printf "\n\033[0;34mOther Commands:\033[0m\n"
	@printf "  make release-init               # Create initial RELEASE_NOTES.md\n"
