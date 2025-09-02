# Example: Using harness-label with Cloud Tag Policy Compliance
# This example demonstrates how to use the harness-label module with tag policy enforcement

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

# Standard usage with tag policy compliance enabled
module "label_compliant" {
  source = "../.."

  # Basic labeling
  namespace   = "harness"
  environment = "prod"
  stage       = "api"
  name        = "user-service"
  attributes  = ["v2"]

  # Tag Policy Compliance - REQUIRED when tag_policy_enabled = true
  tag_policy_enabled = true
  cost_center        = "ENG001"
  owner              = "platform-team@harness.io"
  project            = "user-management"

  # Optional compliance fields
  data_classification = "confidential"
  backup_required     = true
  business_unit       = "Engineering"
  compliance_scope    = ["sox", "gdpr"]
  managed_by          = "terraform"

  # Required tags from organizational policy
  required_tags = {
    "CostAllocation" = "infrastructure"
    "Department"     = "engineering"
    "ServiceTier"    = "tier1"
  }

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

# Example with policy exceptions for legacy resources
module "label_legacy_exception" {
  source = "../.."

  namespace   = "harness"
  environment = "legacy"
  name        = "old-service"

  # Enable policy but skip certain validations for legacy systems
  tag_policy_enabled = true
  cost_center        = "LEGACY"
  owner              = "legacy-team@harness.io"

  # Skip project validation for legacy systems
  tag_policy_exceptions = ["project_validation"]

  required_tags = {
    "Legacy"    = "true"
    "Migration" = "planned"
  }
}

# Example with policy disabled for development
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
