# Harness Terraform Module Makefile
# Standardized build and validation tools for Terraform modules
# Version: 1.0.0

SHELL := /bin/bash
.DEFAULT_GOAL := help
.PHONY: help init validate format lint security test docs clean all pre-commit

# Module information
MODULE_NAME := $(shell basename $(CURDIR))
TF_VERSION := $(shell terraform version -json 2>/dev/null | jq -r '.terraform_version' 2>/dev/null || echo "unknown")

## Display help information
help:
	@printf "\033[0;34mHarness Terraform Module: $(MODULE_NAME)\033[0m\n"
	@printf "\033[0;34mTerraform Version: $(TF_VERSION)\033[0m\n\n"
	@printf "\033[0;33mAvailable targets:\033[0m\n"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[0;32m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@printf "\n\033[0;33mCommon workflows:\033[0m\n"
	@printf "  \033[0;32mmake all\033[0m        - Full validation and documentation generation\n"
	@printf "  \033[0;32mmake pre-commit\033[0m - Run pre-commit checks (format, validate, docs)\n"
	@printf "  \033[0;32mmake test\033[0m       - Run all tests and validations\n"

## Initialize Terraform and install dependencies
init:
	@printf "\033[0;34mInitializing Terraform...\033[0m\n"
	@terraform init -upgrade
	@if [ -d "examples" ]; then \
		for example in examples/*/; do \
			if [ -f "$$example/main.tf" ]; then \
				printf "\033[0;34mInitializing example: $$example\033[0m\n"; \
				(cd "$$example" && terraform init -upgrade); \
			fi; \
		done; \
	fi

## Validate Terraform configuration
validate: init
	@printf "\033[0;34mValidating Terraform configuration...\033[0m\n"
	@terraform validate
	@if [ -d "examples" ]; then \
		for example in examples/*/; do \
			if [ -f "$$example/main.tf" ]; then \
				printf "\033[0;34mValidating example: $$example\033[0m\n"; \
				(cd "$$example" && terraform validate); \
			fi; \
		done; \
	fi
	@printf "\033[0;32m✓ Terraform validation passed\033[0m\n"

## Format Terraform files
format:
	@printf "\033[0;34mFormatting Terraform files...\033[0m\n"
	@terraform fmt -recursive -diff
	@printf "\033[0;32m✓ Terraform formatting complete\033[0m\n"

## Check Terraform formatting without making changes
format-check:
	@printf "\033[0;34mChecking Terraform formatting...\033[0m\n"
	@if ! terraform fmt -recursive -check -diff; then \
		printf "\033[0;31m✗ Terraform files need formatting. Run 'make format' to fix.\033[0m\n"; \
		exit 1; \
	fi
	@printf "\033[0;32m✓ Terraform formatting is correct\033[0m\n"

## Run linting with tflint (if available)
lint:
	@printf "\033[0;34mRunning Terraform linting...\033[0m\n"
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
		if [ -f "scripts/generate-readme.py" ]; then \
			python3 scripts/generate-readme.py; \
			printf "\033[0;32m✓ README.md generated from README.yaml\033[0m\n"; \
		else \
			printf "\033[0;31m✗ Documentation generator not found at scripts/generate-readme.py\033[0m\n"; \
			exit 1; \
		fi; \
	else \
		printf "\033[0;33m⚠ README.yaml not found. Skipping documentation generation.\033[0m\n"; \
	fi

## Generate Terraform documentation with terraform-docs (if available)
docs-tf:
	@printf "\033[0;34mGenerating Terraform documentation...\033[0m\n"
	@if command -v terraform-docs >/dev/null 2>&1; then \
		terraform-docs markdown table --output-file TERRAFORM.md .; \
		printf "\033[0;32m✓ TERRAFORM.md generated\033[0m\n"; \
	else \
		printf "\033[0;33m⚠ terraform-docs not installed. Skipping Terraform docs.\033[0m\n"; \
		printf "\033[0;33m  Install with: brew install terraform-docs\033[0m\n"; \
	fi

## Run Terraform plan for examples (requires AWS credentials)
plan:
	@printf "\033[0;34mRunning Terraform plan for examples...\033[0m\n"
	@if [ -d "examples" ]; then \
		for example in examples/*/; do \
			if [ -f "$$example/main.tf" ]; then \
				printf "\033[0;34mPlanning example: $$example\033[0m\n"; \
				(cd "$$example" && terraform plan -out=tfplan); \
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
	@printf "\033[0;32m✓ Cleanup complete\033[0m\n"

## Run pre-commit checks (formatting, validation, documentation)
pre-commit: format validate docs
	@printf "\033[0;32m✓ Pre-commit checks completed\033[0m\n"

## Run full validation and documentation generation
all: clean init format validate lint security docs docs-tf
	@printf "\033[0;32m✓ Complete module validation and documentation generation finished\033[0m\n"

## Install required tools (macOS with Homebrew)
install-tools:
	@printf "\033[0;34mInstalling required tools...\033[0m\n"
	@if command -v brew >/dev/null 2>&1; then \
		brew install terraform tflint tfsec terraform-docs; \
		npm install -g @cloudposse/readme; \
		printf "\033[0;32m✓ Tools installed\033[0m\n"; \
	else \
		printf "\033[0;31m✗ Homebrew not found. Please install tools manually:\033[0m\n"; \
		echo "  - terraform: https://www.terraform.io/downloads.html"; \
		echo "  - tflint: https://github.com/terraform-linters/tflint"; \
		echo "  - tfsec: https://github.com/aquasecurity/tfsec"; \
		echo "  - terraform-docs: https://github.com/terraform-docs/terraform-docs"; \
		echo "  - readme: npm install -g @cloudposse/readme"; \
	fi

## Show module information and status
info:
	@printf "\033[0;34mModule Information:\033[0m\n"
	@echo "  Name: $(MODULE_NAME)"
	@echo "  Path: $(CURDIR)"
	@echo "  Terraform Version: $(TF_VERSION)"
	@echo ""
	@printf "\033[0;34mFile Status:\033[0m\n"
	@echo "  Terraform files: $$(find . -name '*.tf' | wc -l | tr -d ' ')"
	@echo "  Example directories: $$(find examples -maxdepth 1 -type d 2>/dev/null | grep -v '^examples$$' | wc -l | tr -d ' ' || echo '0')"
	@echo "  Documentation files: $$(ls -1 *.md 2>/dev/null | wc -l | tr -d ' ')"
	@echo ""
	@printf "\033[0;34mTool Status:\033[0m\n"
	@command -v terraform >/dev/null 2>&1 && echo "  ✓ terraform" || echo "  ✗ terraform"
	@command -v tflint >/dev/null 2>&1 && echo "  ✓ tflint" || echo "  ✗ tflint"
	@command -v tfsec >/dev/null 2>&1 && echo "  ✓ tfsec" || echo "  ✗ tfsec"
	@command -v terraform-docs >/dev/null 2>&1 && echo "  ✓ terraform-docs" || echo "  ✗ terraform-docs"
	@command -v readme >/dev/null 2>&1 && echo "  ✓ readme" || echo "  ✗ readme"
