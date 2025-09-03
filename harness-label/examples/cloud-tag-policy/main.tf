# Example: Using harness-label with RFC Cloud Tag Policy Compliance
# This example demonstrates how to use the harness-label module with RFC tag policy enforcement
# RFC requires ALL LOWERCASE tag keys and values

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

# Production usage with full RFC compliance
module "label_compliant" {
  source = "../.."

  # Basic labeling
  namespace   = "harness"
  environment = "prod"
  stage       = "api"
  name        = "user-service"
  attributes  = ["v2"]

  # RFC Tag Policy Compliance - REQUIRED when tag_policy_enabled = true (ALL LOWERCASE)
  tag_policy_enabled = true
  
  # Required RFC tags (always required when policy enabled)
  bu          = "harness"           # Business Unit: harness, split, traceable
  cost_center = "saas_ops"          # For Engineering: PROD=saas_ops, R&D=engineering_dev
  module      = "pl"               # Module owner: ccm, pl, pie, etc.
  team        = "sre"              # Team owner: sre, cs, pie, gitops, ffm-green
  env         = "prod"             # Environment: prod, setup, dev, pov
  
  # Optional RFC tags (only include if needed)
  owner              = "platform-team@harness.io"  # Optional: resource owner
  uuid               = "019634d4-1836-7776-9049-915bb3b6826f"  # Optional: UUIDv7
  expected_end_date  = "2025-12-31"                # Optional: auto-shutdown date
  reason             = "engops-123"                 # Optional: purpose/ticket

  # Additional custom tags
  tags = {
    "Version"    = "2.1.0"
    "Repository" = "harness/user-service"
    "Monitoring" = "enabled"
  }
}

# Example AWS resource using compliant tags
resource "aws_s3_bucket" "example" {
  bucket = module.label_compliant.id
  tags   = module.label_compliant.tags
}

resource "aws_s3_bucket_versioning" "example" {
  bucket = aws_s3_bucket.example.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Legacy resource with policy exceptions
module "label_legacy_exception" {
  source = "../.."

  namespace   = "harness"
  environment = "legacy"
  name        = "old-service"

  # Enable policy but skip certain validations for legacy systems
  tag_policy_enabled = true

  # Required RFC tags
  bu          = "harness"
  cost_center = "legacy_ops"
  module      = "legacy"
  team        = "platform"
  env         = "setup"
  
  # Skip team validation for legacy systems
  tag_policy_exceptions = ["team_validation"]
  
  # Optional RFC tags for legacy tracking
  reason = "legacy_migration"
}

# Development resource with policy disabled
module "label_dev_no_policy" {
  source = "../.."

  namespace   = "harness"
  environment = "dev"
  name        = "test-service"

  # Disable policy enforcement for development environments
  tag_policy_enabled = false

  tags = {
    "Developer" = "john.doe"
    "Temporary" = "true"
  }
}

# Outputs to show policy compliance status
output "compliant_tags" {
  description = "Tags for the compliant resource"
  value       = module.label_compliant.tags
}

output "policy_compliance_status" {
  description = "Policy compliance status"
  value = {
    enabled            = module.label_compliant.tag_policy_enabled
    compliant          = module.label_compliant.policy_compliant
    validation_results = module.label_compliant.policy_validation_results
    required_tags      = module.label_compliant.policy_required_tags
    compliance_tags    = module.label_compliant.policy_compliance_tags
  }
}

output "legacy_compliance_status" {
  description = "Legacy resource compliance status with exceptions"
  value = {
    compliant  = module.label_legacy_exception.policy_compliant
    exceptions = module.label_legacy_exception.tag_policy_exceptions
  }
}

output "resource_id" {
  description = "Generated resource ID"
  value       = module.label_compliant.id
}

output "full_id" {
  description = "Full resource ID (not truncated)"
  value       = module.label_compliant.id_full
}
