# harness-label

Enterprise Terraform labeling module with comprehensive cloud tag policy compliance. Generate consistent resource names and tags while enforcing organizational policies and compliance frameworks.

There are 6 inputs considered "labels" or "ID elements" (because the labels are used to construct the ID):
1. namespace
1. tenant
1. environment
1. stage
1. name
1. attributes

This module generates IDs using the following convention by default: `{namespace}-{environment}-{stage}-{name}-{attributes}`.
However, it is highly configurable. The delimiter (e.g. `-`) is configurable. Each label item is optional (although you must provide at least one).
So if you prefer the term `stage` to `environment` and do not need `tenant`, you can exclude them
and the label `id` will look like `{namespace}-{stage}-{name}-{attributes}`.
- The `tenant` label was introduced in v0.25.0. To preserve backward compatibility, it is not included by default.
- The `attributes` input is actually a list of strings and `{attributes}` expands to the list elements joined by the delimiter.
- If `attributes` is excluded but `namespace`, `stage`, and `environment` are included, `id` will look like `{namespace}-{environment}-{stage}-{name}`.
  Excluding `attributes` is discouraged, though, because attributes are the main way modules modify the ID to ensure uniqueness when provisioning the same resource types.
- If you want the label items in a different order, you can specify that, too, with the `label_order` list.
- You can set a maximum length for the `id`, and the module will create a (probably) unique name that fits within that length.
  (The module uses a portion of the MD5 hash of the full `id` to represent the missing part, so there remains a slight chance of name collision.)
- You can control the letter case of the generated labels which make up the `id` using `var.label_value_case`.
- By default, all of the non-empty labels are also exported as tags, whether they appear in the `id` or not.
You can control which labels are exported as tags by setting `labels_as_tags` to the list of labels you want exported,
or the empty list `[]` if you want no labels exported as tags at all. Tags passed in via the `tags` variable are
always exported, and regardless of settings, empty labels are never exported as tags.
You can control the case of the tag names (keys) for the labels using `var.label_key_case`.
Unlike the tags generated from the label inputs, tags passed in via the `tags` input are not modified.

There is an unfortunate collision over the use of the key `name`. Cloud Posse uses `name` in this module
to represent the component, such as `eks` or `rds`. AWS uses a tag with the key `Name` to store the full human-friendly
identifier of the thing tagged, which this module outputs as `id`, not `name`. So when converting input labels
to tags, the value of the `Name` key is set to the module `id` output, and there is no tag corresponding to the
module `name` output. An empty `name` label will not prevent the `Name` tag from being exported.

It's recommended to use one `terraform-null-label` module for every unique resource of a given resource type.
For example, if you have 10 instances, there should be 10 different labels.
However, if you have multiple different kinds of resources (e.g. instances, security groups, file systems, and elastic ips), then they can all share the same label assuming they are logically related.

For most purposes, the `id` output is sufficient to create an ID or label for a resource, and if you want a different
ID or a different format, you would instantiate another instance of `null-label` and configure it accordingly. However,
to accomodate situations where you want all the same inputs to generate multiple descriptors, this module provides
the `descriptors` output, which is a map of strings generated according to the format specified by the
`descriptor_formats` input. This feature is intentionally simple and minimally configurable and will not be
enhanced to add more features that are already in `null-label`. See [examples/complete/descriptors.tf](examples/complete/descriptors.tf) for examples.

## Tag Policy Compliance

This module includes comprehensive cloud tag policy compliance functionality:

- **Automatic Policy Tags**: Applies standard compliance tags (CostCenter, Owner, Project, etc.)
- **Required Tag Validation**: Enforces mandatory organizational tags
- **Compliance Framework Support**: Supports SOX, PCI, HIPAA, GDPR, ISO27001, FedRAMP, CCPA
- **Cloud Provider Limits**: Validates tag count and length limits (AWS: 50 tags, 128/256 char limits)
- **Policy Exceptions**: Controlled exceptions for legacy systems
- **Pre-deployment Validation**: Comprehensive validation with detailed error messages

### Tag Policy Quick Start

```hcl
module "compliant_label" {
  source = "harness/label"

  namespace   = "harness"
  environment = "prod"
  name        = "api-service"

  # Enable tag policy compliance
  tag_policy_enabled = true
  cost_center        = "ENG001"
  owner              = "platform@harness.io"
  project            = "user-api"
  
  # Optional compliance fields
  data_classification = "confidential"
  backup_required     = true
  compliance_scope    = ["sox", "gdpr"]
}
```

All Harness Terraform modules use this module to ensure resources can be instantiated multiple times within an account and without conflict.

The Harness convention is to use labels as follows:
- `namespace`: Organization or team identifier, typically "harness" for platform resources
- `tenant`: _(Rarely needed)_ When resources are dedicated to specific customers or tenants
- `environment`: Environment identifier such as 'prod', 'staging', 'dev', or cloud region
- `stage`: Deployment stage or service tier, such as 'api', 'web', 'worker'
- `name`: The name of the service or component, such as 'user-service' or 'gateway'

**NOTE:** This module is enterprise-ready with advanced tag policy compliance features.

- This module requires Terraform >= 0.13.0 for full functionality
- Tag policy features use terraform_data resources for validation
- Compatible with all major cloud providers (AWS, GCP, Azure)
- Supports Kubernetes resource labeling

[![Latest Release](https://img.shields.io/github/release/harness/harness-label.svg?style=for-the-badge)](https://github.com/harness/harness-label/releases/latest)
[![Last Updated](https://img.shields.io/github/last-commit/harness/harness-label.svg?style=for-the-badge)](https://github.com/harness/harness-label/commits)
[![Terraform Registry](https://img.shields.io/badge/terraform-registry-blue.svg?style=for-the-badge)](https://registry.terraform.io/modules/harness/label)

## Usage

## Terraform Documentation

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [terraform_data.policy_validation](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br/>This is for some rare cases where resources want additional configuration of tags<br/>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br/>in the order they appear in the list. New attributes are appended to the<br/>end of the list. The elements of the list are joined by the `delimiter`<br/>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_backup_required"></a> [backup\_required](#input\_backup\_required) | Whether backup is required for this resource. Used for backup policy enforcement. | `bool` | `null` | no |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Business unit responsible for the resource. | `string` | `null` | no |
| <a name="input_compliance_scope"></a> [compliance\_scope](#input\_compliance\_scope) | Set of compliance frameworks this resource must adhere to.<br/>Common values: sox, pci, hipaa, gdpr, iso27001, etc. | `set(string)` | `[]` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br/>See description of individual variables for details.<br/>Leave string and numeric variables as `null` to use default value.<br/>Individual variable settings (non-null) override settings in context object,<br/>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br/>  "additional_tag_map": {},<br/>  "attributes": [],<br/>  "delimiter": null,<br/>  "descriptor_formats": {},<br/>  "enabled": true,<br/>  "environment": null,<br/>  "id_length_limit": null,<br/>  "label_key_case": null,<br/>  "label_order": [],<br/>  "label_value_case": null,<br/>  "labels_as_tags": [<br/>    "unset"<br/>  ],<br/>  "name": null,<br/>  "namespace": null,<br/>  "regex_replace_chars": null,<br/>  "stage": null,<br/>  "tags": {},<br/>  "tenant": null<br/>}</pre> | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Cost center code for billing and financial tracking. Required for compliance when tag\_policy\_enabled is true. | `string` | `null` | no |
| <a name="input_created_by"></a> [created\_by](#input\_created\_by) | User or system that created the resource. Automatically populated if not provided. | `string` | `null` | no |
| <a name="input_data_classification"></a> [data\_classification](#input\_data\_classification) | Data classification level for security and compliance. | `string` | `null` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br/>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br/>Map of maps. Keys are names of descriptors. Values are maps of the form<br/>`{<br/>   format = string<br/>   labels = list(string)<br/>}`<br/>(Type is `any` so the map values can later be enhanced to provide additional options.)<br/>`format` is a Terraform format string to be passed to the `format()` function.<br/>`labels` is a list of labels, in order, to pass to `format()` function.<br/>Label values will be normalized before being passed to `format()` so they will be<br/>identical to how they appear in `id`.<br/>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br/>Set to `0` for unlimited length.<br/>Set to `null` for keep the existing setting, which defaults to `0`.<br/>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br/>Does not affect keys of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper`.<br/>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br/>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br/>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br/>set as tag values, and output by this module individually.<br/>Does not affect values of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br/>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br/>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br/>Default is to include all labels.<br/>Tags with empty values will not be included in the `tags` output.<br/>Set to `[]` to suppress all generated tags.<br/>**Notes:**<br/>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br/>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br/>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br/>  "default"<br/>]</pre> | no |
| <a name="input_managed_by"></a> [managed\_by](#input\_managed\_by) | Tool or system managing this resource. | `string` | `"terraform"` | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br/>This is the only ID element not also included as a `tag`.<br/>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | Email address of the resource owner. Required for compliance when tag\_policy\_enabled is true. | `string` | `null` | no |
| <a name="input_project"></a> [project](#input\_project) | Project identifier for resource organization and billing. Required for compliance when tag\_policy\_enabled is true. | `string` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br/>Characters matching the regex will be removed from the ID elements.<br/>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_required_tags"></a> [required\_tags](#input\_required\_tags) | Map of required tags for cloud resource compliance.<br/>These tags will be automatically added to all resources and validated.<br/>Common required tags include: cost\_center, owner, project, data\_classification, etc. | `map(string)` | `{}` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tag_policy_enabled"></a> [tag\_policy\_enabled](#input\_tag\_policy\_enabled) | Enable cloud tag policy compliance. When enabled, enforces required tags and validation rules. | `bool` | `true` | no |
| <a name="input_tag_policy_exceptions"></a> [tag\_policy\_exceptions](#input\_tag\_policy\_exceptions) | Set of tag policy rules to skip for this resource.<br/>Use sparingly and only when justified. Common exceptions: <br/>'required\_tags', 'cost\_center\_validation', 'owner\_validation' | `set(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br/>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_additional_tag_map"></a> [additional\_tag\_map](#output\_additional\_tag\_map) | The merged additional\_tag\_map |
| <a name="output_attributes"></a> [attributes](#output\_attributes) | List of attributes |
| <a name="output_compliance_scope"></a> [compliance\_scope](#output\_compliance\_scope) | Compliance frameworks this resource must adhere to |
| <a name="output_context"></a> [context](#output\_context) | Merged but otherwise unmodified input to this module, to be used as context input to other modules.<br/>Note: this version will have null values as defaults, not the values actually used as defaults. |
| <a name="output_delimiter"></a> [delimiter](#output\_delimiter) | Delimiter between `namespace`, `tenant`, `environment`, `stage`, `name` and `attributes` |
| <a name="output_descriptors"></a> [descriptors](#output\_descriptors) | Map of descriptors as configured by `descriptor_formats` |
| <a name="output_enabled"></a> [enabled](#output\_enabled) | True if module is enabled, false otherwise |
| <a name="output_environment"></a> [environment](#output\_environment) | Normalized environment |
| <a name="output_id"></a> [id](#output\_id) | Disambiguated ID string restricted to `id_length_limit` characters in total |
| <a name="output_id_full"></a> [id\_full](#output\_id\_full) | ID string not restricted in length |
| <a name="output_id_length_limit"></a> [id\_length\_limit](#output\_id\_length\_limit) | The id\_length\_limit actually used to create the ID, with `0` meaning unlimited |
| <a name="output_label_order"></a> [label\_order](#output\_label\_order) | The naming order actually used to create the ID |
| <a name="output_name"></a> [name](#output\_name) | Normalized name |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | Normalized namespace |
| <a name="output_normalized_context"></a> [normalized\_context](#output\_normalized\_context) | Normalized context of this module |
| <a name="output_policy_compliance_tags"></a> [policy\_compliance\_tags](#output\_policy\_compliance\_tags) | Standard compliance tags applied based on policy variables |
| <a name="output_policy_compliant"></a> [policy\_compliant](#output\_policy\_compliant) | Whether the resource tags meet all policy compliance requirements |
| <a name="output_policy_required_tags"></a> [policy\_required\_tags](#output\_policy\_required\_tags) | Tags required by policy that were applied to this resource |
| <a name="output_policy_validation_results"></a> [policy\_validation\_results](#output\_policy\_validation\_results) | Detailed validation results for tag policy compliance checks |
| <a name="output_regex_replace_chars"></a> [regex\_replace\_chars](#output\_regex\_replace\_chars) | The regex\_replace\_chars actually used to create the ID |
| <a name="output_stage"></a> [stage](#output\_stage) | Normalized stage |
| <a name="output_tag_policy_enabled"></a> [tag\_policy\_enabled](#output\_tag\_policy\_enabled) | Whether tag policy compliance enforcement is enabled |
| <a name="output_tag_policy_exceptions"></a> [tag\_policy\_exceptions](#output\_tag\_policy\_exceptions) | Policy rules that were skipped for this resource |
| <a name="output_tags"></a> [tags](#output\_tags) | Normalized Tag map |
| <a name="output_tags_as_list_of_maps"></a> [tags\_as\_list\_of\_maps](#output\_tags\_as\_list\_of\_maps) | This is a list with one map for each `tag`. Each map contains the tag `key`,<br/>`value`, and contents of `var.additional_tag_map`. Used in the rare cases<br/>where resources need additional configuration information for each tag. |
| <a name="output_tenant"></a> [tenant](#output\_tenant) | Normalized tenant |

## License

APACHE2

---

This README was generated from [README.yaml](README.yaml) using the Harness documentation generator.
