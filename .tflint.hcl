# TFLint configuration for Harness Terraform modules
# https://github.com/terraform-linters/tflint

config {
  # Enable all rules by default
  disabled_by_default = false

  # Call modules recursively
  call_module_type = "all"

  # Force provider version constraints
  force = false
}

# AWS Provider plugin for enhanced AWS-specific checks
plugin "aws" {
  enabled = true
  version = "0.31.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

# Terraform core rules
rule "terraform_deprecated_interpolation" {
  enabled = true
}

rule "terraform_deprecated_index" {
  enabled = true
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_comment_syntax" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_typed_variables" {
  enabled = true
}

rule "terraform_module_pinned_source" {
  enabled = true
  style = "semver"
}

rule "terraform_naming_convention" {
  enabled = true
  format = "snake_case"
}

rule "terraform_required_version" {
  enabled = true
}

rule "terraform_required_providers" {
  enabled = true
}

rule "terraform_standard_module_structure" {
  enabled = true
}

rule "terraform_workspace_remote" {
  enabled = true
}

# AWS-specific rules (when AWS plugin is enabled)
rule "aws_instance_invalid_type" {
  enabled = true
}

rule "aws_instance_previous_type" {
  enabled = true
}

rule "aws_route_specified_multiple_targets" {
  enabled = true
}

rule "aws_route_not_specified_target" {
  enabled = true
}

rule "aws_alb_invalid_security_group" {
  enabled = true
}

rule "aws_alb_invalid_subnet" {
  enabled = true
}

rule "aws_elasticache_cluster_invalid_type" {
  enabled = true
}

rule "aws_instance_invalid_ami" {
  enabled = false  # Disabled as AMI IDs are region-specific
}

rule "aws_instance_invalid_key_name" {
  enabled = false  # Disabled as key names are account-specific
}
