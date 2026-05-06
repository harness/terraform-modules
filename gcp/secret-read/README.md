# secret-read

A Terraform module for reading secrets from Google Cloud Secret Manager.

## Usage

### Basic Example

```hcl
module "secret_read" {
  source = "./secret-read"

  project   = "my-gcp-project"
  region    = "us-central1"

  # Label configuration
  namespace   = "harness"
  stage       = "prod"
  description = "api-key"
  attributes  = ["v1"]
}

# The secret data can be accessed via:
# module.secret_read.data
```

### Complete Example

```hcl
module "secret_read" {
  source = "./secret-read"

  project = "my-gcp-project"
  region  = "us-central1"

  # Label configuration
  namespace   = "harness"
  stage       = "prod"
  description = "database-password"
  attributes  = ["postgres", "v2"]

  # Additional context
  context = {
    enabled = true
    tags = {
      Team = "platform"
      Env  = "production"
    }
  }
}

# Use the secret in other resources
resource "kubernetes_secret" "app_secret" {
  metadata {
    name = "app-database-secret"
  }

  data = {
    password = module.secret_read.data
  }
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
| namespace | ID element. Usually an abbreviation of your organization name | `string` | n/a | yes |
| stage | ID element. Usually used to indicate role | `string` | `null` | no |
| description | ID element. Usually the component or solution name | `string` | `null` | no |
| attributes | ID element. Additional attributes to add to `id` | `list(string)` | `[]` | no |
| context | Single object for setting entire context at once | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | ID of the secret |
| name | Normalized name of the secret |
| data | The secret data retrieved from Google Secret Manager (sensitive) |
| secret_name | Name/ID of the secret in Google Secret Manager |
| version | Version of the secret that was retrieved |
| create_time | The time at which the secret version was created |
| enabled | Whether the module is enabled |

## Notes

- The secret must already exist in Google Secret Manager
- The secret name is constructed using the harness labeling convention
- The secret data output is marked as sensitive
- Requires appropriate IAM permissions to read secrets from Secret Manager