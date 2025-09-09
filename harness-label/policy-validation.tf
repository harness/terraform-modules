# Cloud Tag Policy Validation Checks
# This file contains validation rules and checks to enforce cloud tag policy compliance

# Validation: Required policy tags must be provided when policy is enabled
resource "terraform_data" "policy_validation" {
  count = local.input.tag_policy_enabled ? 1 : 0

  lifecycle {
    # RFC Required Tags Validation
    precondition {
      condition     = !contains(local.input.tag_policy_exceptions, "bu_validation") ? local.input.bu != null : true
      error_message = "Business Unit (bu) is required when tag policy is enabled. Set var.bu or add 'bu_validation' to tag_policy_exceptions."
    }

    precondition {
      condition     = !contains(local.input.tag_policy_exceptions, "cost_center_validation") ? local.input.cost_center != null : true
      error_message = "Cost center is required when tag policy is enabled. Set var.cost_center or add 'cost_center_validation' to tag_policy_exceptions."
    }

    precondition {
      condition     = !contains(local.input.tag_policy_exceptions, "module_validation") ? local.input.module != null : true
      error_message = "Module is required when tag policy is enabled. Set var.module or add 'module_validation' to tag_policy_exceptions."
    }

    precondition {
      condition     = !contains(local.input.tag_policy_exceptions, "team_validation") ? local.input.team != null : true
      error_message = "Team is required when tag policy is enabled. Set var.team or add 'team_validation' to tag_policy_exceptions."
    }

    precondition {
      condition     = !contains(local.input.tag_policy_exceptions, "env_validation") ? local.input.env != null : true
      error_message = "Environment (env) is required when tag policy is enabled. Set var.env or add 'env_validation' to tag_policy_exceptions."
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

  }
}

# Optional: Policy compliance check that warns but doesn't fail
check "tag_policy_compliance" {
  assert {
    condition     = local.input.tag_policy_enabled ? local.policy_compliant : true
    error_message = "Resource does not meet tag policy compliance requirements. Check policy_validation_results output for details."
  }
}
