output "id" {
  value       = local.enabled ? local.id : ""
  description = "Disambiguated ID string restricted to `id_length_limit` characters in total"
}

output "id_full" {
  value       = local.enabled ? local.id_full : ""
  description = "ID string not restricted in length"
}

output "enabled" {
  value       = local.enabled
  description = "True if module is enabled, false otherwise"
}

output "namespace" {
  value       = local.enabled ? local.namespace : ""
  description = "Normalized namespace"
}

output "tenant" {
  value       = local.enabled ? local.tenant : ""
  description = "Normalized tenant"
}

output "environment" {
  value       = local.enabled ? local.environment : ""
  description = "Normalized environment"
}

output "name" {
  value       = local.enabled ? local.name : ""
  description = "Normalized name"
}

output "stage" {
  value       = local.enabled ? local.stage : ""
  description = "Normalized stage"
}

output "delimiter" {
  value       = local.enabled ? local.delimiter : ""
  description = "Delimiter between `namespace`, `tenant`, `environment`, `stage`, `name` and `attributes`"
}

output "attributes" {
  value       = local.enabled ? local.attributes : []
  description = "List of attributes"
}

output "tags" {
  value       = local.enabled ? local.tags : {}
  description = "Normalized Tag map"
}

output "additional_tag_map" {
  value       = local.additional_tag_map
  description = "The merged additional_tag_map"
}

output "label_order" {
  value       = local.label_order
  description = "The naming order actually used to create the ID"
}

output "regex_replace_chars" {
  value       = local.regex_replace_chars
  description = "The regex_replace_chars actually used to create the ID"
}

output "id_length_limit" {
  value       = local.id_length_limit
  description = "The id_length_limit actually used to create the ID, with `0` meaning unlimited"
}

output "tags_as_list_of_maps" {
  value       = local.tags_as_list_of_maps
  description = <<-EOT
    This is a list with one map for each `tag`. Each map contains the tag `key`,
    `value`, and contents of `var.additional_tag_map`. Used in the rare cases
    where resources need additional configuration information for each tag.
    EOT
}

output "descriptors" {
  value       = local.descriptors
  description = "Map of descriptors as configured by `descriptor_formats`"
}

output "normalized_context" {
  value       = local.output_context
  description = "Normalized context of this module"
}

output "context" {
  value       = local.output_context
  description = <<-EOT
  Merged but otherwise unmodified input to this module, to be used as context input to other modules.
  Note: this version will have null values as defaults, not the values actually used as defaults.
EOT
}

# Cloud Tag Policy Outputs
output "tag_policy_enabled" {
  value       = local.input.tag_policy_enabled
  description = "Whether tag policy compliance enforcement is enabled"
}

output "policy_compliant" {
  value       = local.policy_compliant
  description = "Whether the resource tags meet all policy compliance requirements"
}

output "policy_validation_results" {
  value       = local.policy_validation_results
  description = "Detailed validation results for tag policy compliance checks"
}

output "policy_required_tags" {
  value       = local.policy_required_tags
  description = "Tags required by policy that were applied to this resource"
}

output "policy_compliance_tags" {
  value       = local.policy_compliance_tags
  description = "Standard compliance tags applied based on policy variables"
}


output "tag_policy_exceptions" {
  value       = local.input.tag_policy_exceptions
  description = "Policy rules that were skipped for this resource"
}

