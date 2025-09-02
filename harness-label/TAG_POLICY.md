# Cloud Tag Policy Compliance

This module now includes comprehensive cloud tag policy compliance functionality to help enforce organizational tagging standards across cloud resources.

## Overview

The tag policy feature automatically applies standardized tags, validates compliance requirements, and enforces organizational policies for cloud resource management.

## Key Features

- **Automatic Policy Tags**: Applies standard compliance tags based on provided variables
- **Required Tag Validation**: Enforces mandatory tags with validation rules
- **Compliance Framework Support**: Supports multiple compliance frameworks (SOX, PCI, HIPAA, GDPR, etc.)
- **Tag Limit Validation**: Ensures compliance with cloud provider tag limits
- **Policy Exceptions**: Allows controlled exceptions for specific use cases
- **Comprehensive Validation**: Pre-deployment validation with detailed error messages

## Quick Start

```hcl
module "label" {
  source = "path/to/harness-label"

  # Basic labeling
  namespace   = "harness"
  environment = "prod"
  name        = "api-service"

  # Tag Policy Compliance (Required when enabled)
  tag_policy_enabled = true
  cost_center        = "ENG001"
  owner              = "team@harness.io"
  project            = "platform-api"

  # Optional compliance fields
  data_classification = "confidential"
  backup_required     = true
  compliance_scope    = ["sox", "gdpr"]
}
```

## Policy Variables

### Required Variables (when `tag_policy_enabled = true`)

| Variable | Type | Description | Validation |
|----------|------|-------------|------------|
| `cost_center` | string | Cost center code for billing | 3-10 uppercase alphanumeric |
| `owner` | string | Email of resource owner | Valid email format |  
| `project` | string | Project identifier | 2-30 lowercase with hyphens |

### Optional Policy Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `data_classification` | string | null | Security classification level |
| `backup_required` | bool | null | Whether backup is required |
| `business_unit` | string | null | Responsible business unit |
| `compliance_scope` | set(string) | [] | Compliance frameworks |
| `managed_by` | string | "terraform" | Management tool |
| `required_tags` | map(string) | {} | Organization-specific required tags |

## Automatic Tags Applied

When tag policy is enabled, the following tags are automatically applied:

- `CostCenter`: From `cost_center` variable
- `Owner`: From `owner` variable  
- `Project`: From `project` variable
- `DataClassification`: From `data_classification` variable
- `BackupRequired`: From `backup_required` variable
- `BusinessUnit`: From `business_unit` variable
- `ManagedBy`: From `managed_by` variable
- `ComplianceScope`: Comma-separated list from `compliance_scope`
- `CreatedDate`: Automatic timestamp (YYYY-MM-DD)
- `LastModified`: Automatic timestamp (ISO 8601)

## Validation Rules

The module enforces the following validation rules:

### Pre-deployment Validation
- Required policy variables must be provided
- All required tags must be present
- Tag count must not exceed 50 (AWS limit)
- Tag keys must not exceed 128 characters
- Tag values must not exceed 256 characters
- Compliance scopes must be recognized values

### Supported Compliance Frameworks
- `sox` - Sarbanes-Oxley
- `pci` - Payment Card Industry
- `hipaa` - Health Insurance Portability and Accountability Act
- `gdpr` - General Data Protection Regulation
- `iso27001` - ISO 27001
- `fedramp` - Federal Risk and Authorization Management Program
- `ccpa` - California Consumer Privacy Act

## Policy Exceptions

Use `tag_policy_exceptions` to skip specific validation rules:

```hcl
module "legacy_resource" {
  source = "path/to/harness-label"
  
  tag_policy_enabled = true
  cost_center        = "LEGACY001"
  owner              = "legacy-team@harness.io"
  
  # Skip project validation for legacy systems
  tag_policy_exceptions = ["project_validation"]
}
```

Available exceptions:
- `required_tags` - Skip required tag validation
- `cost_center_validation` - Skip cost center requirement
- `owner_validation` - Skip owner requirement
- `project_validation` - Skip project requirement

## Outputs

The module provides comprehensive policy compliance outputs:

- `policy_compliant`: Boolean indicating full compliance
- `policy_validation_results`: Detailed validation results
- `policy_required_tags`: Applied required tags
- `policy_compliance_tags`: Applied compliance tags
- `tag_policy_exceptions`: Active exceptions

## Usage Examples

### Standard Compliant Resource
```hcl
module "production_service" {
  source = "path/to/harness-label"

  namespace   = "harness"
  environment = "prod"
  name        = "user-api"

  tag_policy_enabled  = true
  cost_center         = "ENG001"
  owner               = "platform@harness.io"
  project             = "user-management"
  data_classification = "confidential"
  backup_required     = true
  compliance_scope    = ["sox", "gdpr"]

  required_tags = {
    "ServiceTier" = "tier1"
    "Department"  = "engineering"
  }
}
```

### Development Environment (Policy Disabled)
```hcl
module "dev_service" {
  source = "path/to/harness-label"

  namespace   = "harness"
  environment = "dev"
  name        = "test-api"

  # Disable policy for development
  tag_policy_enabled = false

  tags = {
    "Developer" = "john.doe"
    "Feature"   = "user-auth"
  }
}
```

### Legacy System with Exceptions
```hcl
module "legacy_system" {
  source = "path/to/harness-label"

  namespace = "legacy"
  name      = "old-system"

  tag_policy_enabled = true
  cost_center        = "MAINT001"
  owner              = "maintenance@harness.io"

  # Skip project requirement for legacy systems
  tag_policy_exceptions = ["project_validation"]

  required_tags = {
    "Legacy"    = "true"
    "Migration" = "planned"
  }
}
```

## Migration Guide

To add tag policy compliance to existing resources:

1. **Enable Policy Gradually**: Start with `tag_policy_enabled = false` and add policy variables
2. **Add Required Variables**: Provide `cost_center`, `owner`, and `project`
3. **Enable Policy**: Set `tag_policy_enabled = true`  
4. **Handle Validation Errors**: Use exceptions for legacy systems if needed
5. **Monitor Compliance**: Use `policy_compliant` output to track compliance status

## Best Practices

- **Centralize Configuration**: Use Terraform data sources or variables for common policy values
- **Environment-Specific Policies**: Different requirements for prod vs dev environments
- **Automate Compliance Reporting**: Use policy outputs for compliance dashboards
- **Document Exceptions**: Clearly document why exceptions are used
- **Regular Audits**: Review and validate tag compliance regularly

## Troubleshooting

### Common Validation Errors

**"Cost center is required"**
- Provide `cost_center` variable or add `cost_center_validation` to exceptions

**"Missing required tags"**  
- Ensure all `required_tags` are provided or add `required_tags` to exceptions

**"Tag count exceeds limit"**
- Reduce number of tags or disable policy validation for testing

**"Invalid compliance scope"**
- Use only supported compliance framework values

### Debugging Policy Issues

Use the policy outputs to debug compliance issues:

```hcl
output "debug_policy" {
  value = {
    enabled            = module.label.tag_policy_enabled
    compliant          = module.label.policy_compliant  
    validation_results = module.label.policy_validation_results
    applied_tags       = module.label.tags
  }
}
```
