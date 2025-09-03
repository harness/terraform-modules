# Cloud Tag Policy Validation Checks
# This file contains validation rules and checks to enforce cloud tag policy compliance

# Validation: Required policy tags must be provided when policy is enabled
resource "terraform_data" "policy_validation" {
  count = var.tag_policy_enabled ? 1 : 0

  lifecycle {
    # Fail if required policy tags are missing
    precondition {
      condition     = !contains(var.tag_policy_exceptions, "cost_center_validation") ? var.cost_center != null : true
      error_message = "Cost center is required when tag policy is enabled. Set var.cost_center or add 'cost_center_validation' to tag_policy_exceptions."
    }

    precondition {
      condition     = !contains(var.tag_policy_exceptions, "owner_validation") ? var.owner != null : true
      error_message = "Owner email is required when tag policy is enabled. Set var.owner or add 'owner_validation' to tag_policy_exceptions."
    }

    precondition {
      condition     = !contains(var.tag_policy_exceptions, "project_validation") ? var.project != null : true
      error_message = "Project identifier is required when tag policy is enabled. Set var.project or add 'project_validation' to tag_policy_exceptions."
    }

    # Validate all required tags are present
    precondition {
      condition = !contains(var.tag_policy_exceptions, "required_tags") ? alltrue([
        for required_tag in keys(var.required_tags) : contains(keys(local.tags), required_tag)
      ]) : true
      error_message = "Missing required tags: ${join(", ", [for tag in keys(var.required_tags) : tag if !contains(keys(local.tags), tag)])}. Provide values or add 'required_tags' to tag_policy_exceptions."
    }

    # Validate tag count limits
    precondition {
      condition     = length(keys(local.tags)) <= 50
      error_message = "Tag count (${length(keys(local.tags))}) exceeds AWS limit of 50 tags. Reduce tag count or disable policy validation."
    }

    # Validate tag key lengths
    precondition {
      condition     = alltrue([for k in keys(local.tags) : length(k) <= 128])
      error_message = "Tag key length exceeds AWS limit of 128 characters: ${join(", ", [for k in keys(local.tags) : k if length(k) > 128])}"
    }

    # Validate tag value lengths  
    precondition {
      condition     = alltrue([for v in values(local.tags) : length(v) <= 256])
      error_message = "Tag value length exceeds AWS limit of 256 characters."
    }

    # Validate compliance scopes are recognized
    precondition {
      condition = alltrue([
        for scope in var.compliance_scope :
        contains(["sox", "pci", "hipaa", "gdpr", "iso27001", "fedramp", "ccpa"], scope)
      ])
      error_message = "Invalid compliance scope(s): ${join(", ", [for scope in var.compliance_scope : scope if !contains(["sox", "pci", "hipaa", "gdpr", "iso27001", "fedramp", "ccpa"], scope)])}. Valid values: sox, pci, hipaa, gdpr, iso27001, fedramp, ccpa."
    }
  }
}

# Optional: Policy compliance check that warns but doesn't fail
check "tag_policy_compliance" {
  assert {
    condition     = var.tag_policy_enabled ? local.policy_compliant : true
    error_message = "Resource does not meet tag policy compliance requirements. Check policy_validation_results output for details."
  }
}
