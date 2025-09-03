# RFC Cloud Tag Policy Compliance

This module enforces **RFC Cloud Tag Policy** compliance with **ALL LOWERCASE** tag keys and values as specified in the Harness Engineering RFC.

## RFC Requirements Overview

The RFC defines a standardized tagging approach with:
- **Required Tags**: Always enforced when policy is enabled
- **Optional Tags**: Included only when provided
- **ALL LOWERCASE**: Tag keys and values must be lowercase only
- **Standardized Values**: Predefined valid values for consistency

## Key Features

- **RFC Compliance**: Enforces exact RFC tag requirements
- **Required Tag Validation**: Validates all 5 required RFC tags
- **Lowercase Enforcement**: Ensures all tags are lowercase per RFC
- **Policy Exceptions**: Controlled exceptions for legacy resources
- **Pre-deployment Validation**: Catches compliance issues before deployment

## Quick Start (RFC Compliant)

```hcl
module "label" {
  source = "path/to/harness-label"

  # Basic labeling
  namespace   = "harness"
  environment = "prod"
  name        = "api-service"

  # RFC Tag Policy Compliance - ALL REQUIRED when policy enabled
  tag_policy_enabled = true
  bu          = "harness"           # Business Unit: harness, split, traceable
  cost_center = "saas_ops"          # Engineering: saas_ops (prod), engineering_dev (r&d)
  module      = "pl"               # Module owner: ccm, pl, pie, etc.
  team        = "sre"              # Team: sre, cs, pie, gitops, ffm-green
  env         = "prod"             # Environment: prod, setup, dev, pov

  # Optional RFC tags (include only if needed)
  owner              = "platform-team@harness.io"  # Resource owner
  uuid               = "019634d4-1836-7776-9049-915bb3b6826f"  # UUIDv7
  expected_end_date  = "2025-12-31"                # Auto-shutdown date
  reason             = "engops-123"                 # Purpose/ticket
}
```

## RFC Policy Variables

### Required Variables (when `tag_policy_enabled = true`)

| Variable | Type | Valid Values | Description |
|----------|------|-------------|-------------|
| `bu` | string | `harness`, `split`, `traceable` | Business Unit |
| `cost_center` | string | lowercase alphanumeric + underscores | For Engineering: `saas_ops` (PROD), `engineering_dev` (R&D) |
| `module` | string | lowercase alphanumeric + hyphens/underscores | Module owner (e.g., `ccm`, `pl`, `pie`) |
| `team` | string | lowercase alphanumeric + hyphens/underscores | Team owner (e.g., `sre`, `cs`, `pie`, `gitops`, `ffm-green`) |
| `env` | string | `prod`, `setup`, `dev`, `pov` | Environment type |

### Optional Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `owner` | string | `null` | Resource owner (email/username, lowercase) |
| `uuid` | string | `null` | UUIDv7 preferred, reserved for future use |
| `expected_end_date` | string | `null` | ISO-8601 date (YYYY-MM-DD) for auto-shutdown |
| `reason` | string | `null` | Purpose description, Jira ticket IDs preferred |

## RFC Tags Applied (ALL LOWERCASE)

### Required Tags (always applied when policy enabled):
- `bu`: Business unit (harness, split, traceable)
- `cost-center`: Cost center for billing/tracking
- `module`: Module that owns the resource
- `team`: Team that owns the resource
- `env`: Environment type (prod, setup, dev, pov)

### Optional Tags (applied only when provided):
- `owner`: Resource owner (email/username)
- `uuid`: UUID for external reference
- `expected-end-date`: Auto-shutdown date (ISO-8601)
- `reason`: Purpose description or ticket ID

## RFC Validation Rules

### Pre-deployment Validation
- **All 5 required RFC tags** must be provided when policy is enabled
- **Lowercase enforcement** - all tag keys and values converted to lowercase
- **Valid values only** - predefined values for bu, env, etc.
- **AWS limits** - Tag count ≤ 50, key length ≤ 128 chars, value length ≤ 256 chars

### Value Validation
- **Business Unit**: Must be `harness`, `split`, or `traceable`
- **Cost Center**: Lowercase alphanumeric with underscores only
- **Module**: Lowercase alphanumeric with hyphens/underscores
- **Team**: Lowercase alphanumeric with hyphens/underscores  
- **Environment**: Must be `prod`, `setup`, `dev`, or `pov`
- **Owner**: Lowercase with dots, underscores, @ symbols, hyphens
- **UUID**: Valid UUID format (lowercase)
- **Expected End Date**: ISO-8601 format (YYYY-MM-DD)
- **Reason**: Lowercase alphanumeric with underscores/hyphens

## Policy Exceptions

Use `tag_policy_exceptions` to skip specific RFC validation rules:

```hcl
module "legacy_resource" {
  source = "path/to/harness-label"
  
  tag_policy_enabled = true
  bu          = "harness"
  cost_center = "legacy_ops"
  module      = "legacy"
  env         = "setup"
  
  # Skip team validation for legacy systems
  tag_policy_exceptions = ["team_validation"]
  
  reason = "legacy_migration"
}
```

**Available RFC Exceptions:**
- `bu_validation` - Skip business unit requirement
- `cost_center_validation` - Skip cost center requirement
- `module_validation` - Skip module requirement
- `team_validation` - Skip team requirement
- `env_validation` - Skip environment requirement

**⚠️ Use Sparingly**: Exceptions should only be used for legacy resources with documented justification.

## RFC Compliance Outputs

The module provides RFC compliance status and details:

- `policy_compliant`: Boolean indicating full RFC compliance
- `policy_validation_results`: Detailed validation results for each RFC requirement
- `policy_required_tags`: Applied RFC required tags (bu, cost-center, module, team, env)
- `policy_compliance_tags`: Applied RFC optional tags (owner, uuid, expected-end-date, reason)
- `tag_policy_exceptions`: Active validation exceptions
- `tags`: Final merged tags with RFC compliance applied

## RFC Usage Examples

### Production Service (Full RFC Compliance)
```hcl
module "production_service" {
  source = "path/to/harness-label"

  namespace   = "harness"
  environment = "prod"
  name        = "user-api"

  # All RFC required tags
  tag_policy_enabled = true
  bu          = "harness"        # Business unit
  cost_center = "saas_ops"       # Engineering production cost center
  module      = "pl"            # Platform module
  team        = "sre"           # SRE team owns this
  env         = "prod"          # Production environment

  # RFC optional tags
  owner              = "platform@harness.io"
  uuid               = "019634d4-1836-7776-9049-915bb3b6826f"
  expected_end_date  = "2026-01-01"
  reason             = "engops-456"

  # Additional custom tags (not part of RFC)
  tags = {
    "version"    = "v2.1.0"
    "repository" = "harness/user-api"
  }
}
```

### Development Service (Policy Disabled)
```hcl
module "dev_service" {
  source = "path/to/harness-label"

  namespace   = "harness"
  environment = "dev"
  name        = "test-api"

  # Disable RFC policy for development
  tag_policy_enabled = false

  tags = {
    "developer" = "john.doe"
    "feature"   = "user-auth"
    "temporary" = "true"
  }
}
```

### Legacy System (With Exceptions)
```hcl
module "legacy_system" {
  source = "path/to/harness-label"

  namespace = "legacy"
  name      = "old-system"

  tag_policy_enabled = true
  bu          = "harness"
  cost_center = "legacy_ops"
  module      = "legacy"
  env         = "setup"          # Business impact environment
  
  # Skip team validation - legacy system has no clear team owner
  tag_policy_exceptions = ["team_validation"]

  reason = "legacy_migration"
}
```

### R&D/Engineering Development
```hcl
module "rnd_service" {
  source = "path/to/harness-label"

  namespace   = "research"
  environment = "dev"
  name        = "ml-experiment"

  tag_policy_enabled = true
  bu          = "harness"
  cost_center = "engineering_dev"  # R&D cost center per RFC
  module      = "ccm"             # Cost & Cloud Management
  team        = "research"
  env         = "dev"             # Development/sandbox

  expected_end_date = "2025-06-30"  # Experimental project end date
  reason           = "ml_research_q2"
}
```

## RFC Migration Guide

### Migrating to RFC Compliance

1. **Review Current Tags**: Identify existing resources and their current tagging
2. **Map to RFC Requirements**: Determine RFC values for each resource:
   - What business unit? (`harness`, `split`, `traceable`)
   - What cost center? (`saas_ops`, `engineering_dev`, etc.)
   - What module owns it? (`pl`, `ccm`, `pie`, etc.)
   - What team owns it? (`sre`, `cs`, `pie`, etc.)
   - What environment? (`prod`, `setup`, `dev`, `pov`)
3. **Add RFC Variables**: Update Terraform configurations with RFC variables
4. **Enable Policy**: Set `tag_policy_enabled = true`
5. **Handle Legacy**: Use exceptions sparingly for systems that can't meet requirements
6. **Validate**: Use `policy_compliant` output to confirm compliance

### Breaking Changes from Previous Version

**⚠️ BREAKING CHANGES:**
- **Removed Variables**: `project`, `data_classification`, `backup_required`, `business_unit`, `compliance_scope`, `managed_by`, `required_tags`
- **New Required Variables**: `bu`, `module`, `team`, `env` (when policy enabled)
- **Renamed Variable**: `cost_center` validation changed to lowercase only
- **New Optional Variables**: `uuid`, `expected_end_date`, `reason`
- **Tag Format**: All tags now lowercase per RFC

### Conversion Examples

**Old (Pre-RFC):**
```hcl
cost_center = "ENG001"              # Uppercase
owner = "team@harness.io"
project = "user-management"
data_classification = "confidential"
```

**New (RFC Compliant):**
```hcl
bu = "harness"                      # New required
cost_center = "saas_ops"            # Lowercase, different values
module = "pl"                       # New required  
team = "sre"                        # New required
env = "prod"                        # New required
owner = "team@harness.io"           # Now optional
reason = "user_management"          # Replaces project concept
```

## RFC Best Practices

### Implementation
- **Centralize RFC Values**: Use Terraform variables or data sources for common values like `bu`, `cost_center`
- **Team Registration**: Ensure teams are registered with ENGOPS before using in `team` field
- **Consistent Naming**: Use consistent lowercase naming across all resources
- **Environment Strategy**: Different `env` values for different deployment stages

### Operations
- **Monitor Compliance**: Use `policy_compliant` output for compliance dashboards
- **Document Exceptions**: Always document why exceptions are needed
- **Regular Audits**: Review tag compliance and update values as teams/modules change
- **Cost Tracking**: Use standardized `cost_center` values for accurate billing

### Development Workflow
- **Local Development**: Disable policy (`tag_policy_enabled = false`) for local testing
- **CI/CD Integration**: Validate compliance in CI before deployment
- **Team Ownership**: Ensure each resource has clear `team` ownership
- **Lifecycle Management**: Use `expected_end_date` for temporary resources

## RFC Troubleshooting

### Common RFC Validation Errors

**"Business Unit (bu) is required"**
- Provide `bu` variable with valid value: `harness`, `split`, or `traceable`
- Or add `bu_validation` to exceptions for legacy resources

**"Cost center is required"**
- Provide `cost_center` variable (lowercase alphanumeric with underscores)
- Engineering: use `saas_ops` (PROD) or `engineering_dev` (R&D)

**"Module is required"**
- Provide `module` variable (e.g., `ccm`, `pl`, `pie`)
- Contact module owners to determine correct value

**"Team is required"**
- Provide `team` variable with registered team name
- Team must be registered with ENGOPS
- Use lowercase with hyphens/underscores (e.g., `sre`, `ffm-green`)

**"Environment (env) is required"**
- Provide `env` variable: `prod`, `setup`, `dev`, or `pov`
- `prod` = customer-facing, `setup` = business impact, `dev` = sandbox

**"Tag count exceeds AWS limit"**
- Reduce custom tags or disable policy for testing
- AWS limit: 50 tags per resource

### RFC Validation Debugging

```hcl
output "rfc_debug" {
  value = {
    # Compliance status
    policy_enabled     = module.label.tag_policy_enabled
    rfc_compliant      = module.label.policy_compliant
    
    # Validation details
    validation_results = module.label.policy_validation_results
    
    # Applied RFC tags
    required_tags      = module.label.policy_required_tags
    optional_tags      = module.label.policy_compliance_tags
    
    # Final result
    all_tags          = module.label.tags
    
    # Exceptions used
    exceptions        = module.label.tag_policy_exceptions
  }
}
```

### Getting Help

- **RFC Questions**: Contact ENGOPS team
- **Team Registration**: Work with ENGOPS to register new teams
- **Cost Center Values**: Check with Finance/ENGOPS for valid values
- **Module Ownership**: Contact platform teams to determine module ownership

## RFC Reference

### Complete RFC Tag List

| Tag Key | Required | Valid Values | Example | Notes |
|---------|----------|-------------|---------|-------|
| `bu` | ✅ | `harness`, `split`, `traceable` | `harness` | Business unit |
| `cost-center` | ✅ | lowercase alphanumeric + _ | `saas_ops` | Engineering: saas_ops/engineering_dev |
| `module` | ✅ | lowercase alphanumeric + -_ | `pl` | Module that owns resource |
| `team` | ✅ | lowercase alphanumeric + -_ | `sre` | Team registered with ENGOPS |
| `env` | ✅ | `prod`, `setup`, `dev`, `pov` | `prod` | Environment type |
| `owner` | ❌ | lowercase + @-_. | `john.doe` | Resource owner |
| `uuid` | ❌ | Valid UUID format | `019634d4-...` | UUIDv7 preferred |
| `expected-end-date` | ❌ | YYYY-MM-DD | `2025-12-31` | Auto-shutdown date |
| `reason` | ❌ | lowercase alphanumeric + -_ | `engops-123` | Purpose/ticket ID |

### Environment Types (env)
- **`prod`**: Customer-facing - if it goes down, customers see it
- **`setup`**: Business impact - if it goes down, there's adverse business impact (QA, Analytics)
- **`dev`**: Sandbox/Play accounts - no SLA
- **`pov`**: Proof of value/demo environments

### Engineering Cost Centers
- **`saas_ops`**: Production systems
- **`engineering_dev`**: Research & Development
- **Others**: Contact @Jeffrey Merlin for guidance
