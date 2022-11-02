variable "prefix_name" {}

variable "kms_key_arn" {
  type        = string
  description = "KMS Key ARN used for Vault auto-unseal permissions"
}

variable "secrets_manager_arn" {
  type        = string
  description = "Secrets manager ARN where TLS cert info is stored"
}