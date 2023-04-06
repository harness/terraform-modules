### helm_release

variable "chart" {
  type        = string
  description = "Chart name to be installed. The chart name can be local path, a URL to a chart, or the name of the chart if `repository` is specified. It is also possible to use the `<repository>/<chart>` format here if you are running Terraform on a system that the repository has been added to with `helm repo add` but this is not recommended."
}

variable "release_name" {
  type        = string
  description = "The name of the release to be installed. If omitted, use the name input, and if that's omitted, use the chart input."
  default     = ""
}

variable "description" {
  type        = string
  description = "Release description attribute (visible in the history)."
  default     = null
}

variable "devel" {
  type        = bool
  description = "Use chart development versions, too. Equivalent to version `>0.0.0-0`. If version is set, this is ignored."
  default     = null
}

variable "repository" {
  type        = string
  description = "Repository URL where to locate the requested chart."
  default     = null
}

variable "repository_ca_file" {
  type        = string
  description = "The Repositories CA file."
  default     = null
}

variable "repository_cert_file" {
  type        = string
  description = "The repositories cert file."
  default     = null
}

variable "repository_key_file" {
  type        = string
  description = "The repositories cert key file."
  default     = null
}

variable "repository_password" {
  type        = string
  description = "Password for HTTP basic authentication against the repository."
  default     = null
}

variable "repository_username" {
  type        = string
  description = "Username for HTTP basic authentication against the repository."
  default     = null
}

variable "chart_version" {
  type        = string
  description = "Specify the exact chart version to install. If this is not specified, the latest version is installed."
  default     = null
}

variable "create_namespace" {
  type        = bool
  description = <<-EOT
    (Not recommended, use `create_namespace_with_kubernetes` instead)
    Create the namespace via Helm if it does not yet exist. Defaults to `false`.
    Does not support annotations or labels. May have problems when destroying.
    Ignored when `create_namespace_with_kubernetes` is set.
    EOT
  default     = null
}

variable "kubernetes_namespace" {
  type        = string
  description = "The namespace to install the release into. Defaults to `default`."
  default     = null
}

variable "kubernetes_namespace_annotations" {
  type        = map(string)
  description = "Annotations to be added to the created namespace. Ignored unless `create_namespace_with_kubernetes` is `true`."
  default     = {}
}

variable "kubernetes_namespace_labels" {
  type        = map(string)
  description = "Labels to be added to the created namespace. Ignored unless `create_namespace_with_kubernetes` is `true`."
  default     = {}
}

variable "atomic" {
  type        = bool
  description = "If set, installation process purges chart on fail. The wait flag will be set automatically if atomic is used. Defaults to `false`."
  default     = null
}

variable "cleanup_on_fail" {
  type        = bool
  description = "Allow deletion of new resources created in this upgrade when upgrade fails. Defaults to `false`."
  default     = null
}

variable "dependency_update" {
  type        = bool
  description = "Runs helm dependency update before installing the chart. Defaults to `false`."
  default     = null
}

variable "disable_openapi_validation" {
  type        = bool
  description = "If set, the installation process will not validate rendered templates against the Kubernetes OpenAPI Schema. Defaults to `false`."
  default     = null
}

variable "disable_webhooks" {
  type        = bool
  description = "Prevent hooks from running. Defaults to `false`."
  default     = null
}

variable "force_update" {
  type        = bool
  description = "Force resource update through delete/recreate if needed. Defaults to `false`."
  default     = null
}

variable "keyring" {
  type        = string
  description = "Location of public keys used for verification. Used only if `verify` is true. Defaults to `/.gnupg/pubring.gpg` in the location set by `home`."
  default     = null
}

variable "lint" {
  type        = bool
  description = "Run the helm chart linter during the plan. Defaults to `false`."
  default     = null
}

variable "max_history" {
  type        = number
  description = "Maximum number of release versions stored per release. Defaults to `0` (no limit)."
  default     = null
}

variable "recreate_pods" {
  type        = bool
  description = "Perform pods restart during upgrade/rollback. Defaults to `false`."
  default     = null
}

variable "render_subchart_notes" {
  type        = bool
  description = "If set, render subchart notes along with the parent. Defaults to `true`."
  default     = null
}

variable "replace" {
  type        = bool
  description = "Re-use the given name, even if that name is already used. This is unsafe in production. Defaults to `false`."
  default     = null
}

variable "reset_values" {
  type        = bool
  description = "When upgrading, reset the values to the ones built into the chart. Defaults to `false`."
  default     = null
}

variable "reuse_values" {
  type        = bool
  description = "When upgrading, reuse the last release's values and merge in any overrides. If `reset_values` is specified, this is ignored. Defaults to `false`."
  default     = null
}

variable "skip_crds" {
  type        = bool
  description = "If set, no CRDs will be installed. By default, CRDs are installed if not already present. Defaults to `false`."
  default     = null
}

variable "timeout" {
  type        = number
  description = "Time in seconds to wait for any individual kubernetes operation (like Jobs for hooks). Defaults to `300` seconds."
  default     = null
}

variable "values" {
  type        = any
  description = "List of values in raw yaml to pass to helm. Values will be merged, in order, as Helm does with multiple `-f` options."
  default     = null
}

variable "verify" {
  type        = bool
  description = "Verify the package before installing it. Helm uses a provenance file to verify the integrity of the chart; this must be hosted alongside the chart. For more information see the Helm Documentation. Defaults to `false`."
  default     = null
}

variable "wait" {
  type        = bool
  description = "Will wait until all resources are in a ready state before marking the release as successful. It will wait for as long as `timeout`. Defaults to `true`."
  default     = null
}

variable "wait_for_jobs" {
  type        = bool
  description = "If wait is enabled, will wait until all Jobs have been completed before marking the release as successful. It will wait for as long as `timeout`. Defaults to `false`."
  default     = null
}

variable "set" {
  type = list(object({
    name  = string
    value = string
    type  = string
  }))
  description = "Value block with custom values to be merged with the values yaml."
  default     = []
}

variable "set_sensitive" {
  type = list(object({
    name  = string
    value = string
    type  = string
  }))
  description = "Value block with custom sensitive values to be merged with the values yaml that won't be exposed in the plan's diff."
  default     = []
}

variable "postrender_binary_path" {
  type        = string
  description = "Relative or full path to command binary."
  default     = null
}