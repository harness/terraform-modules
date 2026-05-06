# secret-write

A Terraform module for creating and writing secrets to Google Cloud Secret Manager.

## Usage

### Basic Example

```hcl
module "secret_write" {
  source = "./secret-write"

  project = "my-gcp-project"
  region  = "us-central1"
  data    = "my-secret-value"

  # Label configuration
  namespace   = "harness"
  stage       = "prod"
  description = "api-key"
  attributes  = ["v1"]
}
```

### Complete Example with Custom Replication

```hcl
module "secret_write" {
  source = "./secret-write"

  project = "my-gcp-project"
  region  = "us-central1"
  data    = var.database_password

  # Label configuration
  namespace   = "harness"
  stage       = "prod"
  description = "database-password"
  attributes  = ["postgres", "v2"]

  # Replication configuration
  replication_policy = "user_managed"
  replica_locations  = ["us-central1", "us-east1", "europe-west1"]

  # Additional context
  context = {
    enabled = true
    tags = {
      Team = "platform"
      Env  = "production"
    }
  }
}
```

### Automatic Replication Example

```hcl
module "secret_write" {
  source = "./secret-write"

  project = "my-gcp-project"
  region  = "us-central1"
  data    = "my-secret-value"

  # Label configuration
  namespace   = "harness"
  stage       = "dev"
  description = "test-secret"

  # Use automatic replication
  replication_policy = "automatic"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| google | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| google | >= 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project | GCP Project | `string` | n/a | yes |
| region | GCP Region | `string` | n/a | yes |
| data | Secret Data | `string` | n/a | yes |
| namespace | ID element. Usually an abbreviation of your organization name | `string` | n/a | yes |
| stage | ID element. Usually used to indicate role | `string` | `null` | no |
| description | ID element. Usually the component or solution name | `string` | `null` | no |
| attributes | ID element. Additional attributes to add to `id` | `list(string)` | `[]` | no |
| replication_policy | Replication policy for the secret. Options: 'automatic' or 'user_managed' | `string` | `"user_managed"` | no |
| replica_locations | List of replica locations for user_managed replication | `list(string)` | `["us-central1", "us-east1"]` | no |
| context | Single object for setting entire context at once | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | ID of the secret |
| name | Normalized name of the secret |
| secret_id | The ID of the secret in Google Secret Manager |
| secret_name | The full name of the secret in Google Secret Manager |
| secret_version_id | The ID of the secret version |
| secret_version_name | The full name of the secret version |
| create_time | The time at which the secret was created |
| enabled | Whether the module is enabled |
| replication_policy | The replication policy used for the secret |
| replica_locations | The replica locations used for user_managed replication |

## Replication Policies

### User Managed Replication
- Allows you to specify exact locations where the secret should be replicated
- Provides more control over data residency
- Default locations: `us-central1`, `us-east1`

### Automatic Replication
- Google automatically replicates the secret across multiple regions
- Less control but simplified management
- Google handles the replication strategy

## Notes

- The secret data input is marked as sensitive
- Labels are automatically converted to lowercase for GCP compliance
- Requires appropriate IAM permissions to create secrets in Secret Manager
- The secret name is constructed using the harness labeling convention