variable "aws_region" {
  type        = string
  default     = "ap-south-1"
  description = "Specific AWS region being used"
}

variable "prefix_name"{
  type = string
  default = "vault-servers"
}

variable "cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "10.100.0.0/16"
}

variable "env" {
  type = string
  default = "prod"
}

variable "common_tags" {
  default     = {}
  description = "common resource tags"
  type        = map(string)
}

variable "kms_key_arn" {
  type        = string
  description = "KMS Key ARN used for Vault auto-unseal permissions"
  default     = ""
}

variable "secrets_manager_arn" {
  type        = string
  description = "Secrets manager ARN where TLS cert info is stored"
  default     = ""
}

variable "vault_version" {
  type        = string
  default     = "1.11.0"
  description = "Vault version"
}

variable "user_supplied_ami_id" {
  type        = string
  description = "(Optional) User-provided AMI ID to use with Vault instances. If you provide this value, please ensure it will work with the default userdata script (assumes latest version of Ubuntu LTS). Otherwise, please provide your own userdata script using the user_supplied_userdata_path variable."
  default     = null
}

variable "ssl_policy" {
  type        = string
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
  description = "SSL policy to use on LB listener"
}

variable "permissions_boundary" {
  description = "(Optional) IAM Managed Policy to serve as permissions boundary for created IAM Roles"
  type        = string
  default     = null
}

variable "node_count" {
  type        = number
  default     = 3
  description = "Number of Vault nodes to deploy in ASG"
}

variable "lb_health_check_path" {
  type        = string
  description = "The endpoint to check for Vault's health status."
  default     = "/v1/sys/health?activecode=200&standbycode=200&sealedcode=200&uninitcode=200"
}

variable "lb_deregistration_delay" {
  type        = string
  description = "Amount time, in seconds, for Vault LB target group to wait before changing the state of a deregistering target from draining to unused."
  default     = 300
}

variable "lb_certificate_arn" {
  type        = string
  description = "ARN of TLS certificate imported into ACM for use with LB listener"
  default     = ""
}

variable "leader_tls_servername" {
  type        = string
  description = "One of the shared DNS SAN used to create the certs use for mTLS"
  default     = ""
}

variable "instance_type" {
  type        = string
  default     = "t2.medium"
  description = "EC2 instance type"
}

variable "key_name" {
  type        = string
  default     = null
  description = "(Optional) key pair to use for SSH access to instance"
}

variable "kms_key_deletion_window" {
  type        = number
  default     = 7
  description = "Duration in days after which the key is deleted after destruction of the resource (must be between 7 and 30 days)."
}

variable "allowed_inbound_cidrs_lb" {
  type        = list(string)
  description = "List of CIDR blocks to permit inbound traffic from to load balancer"
  default     = null
}

variable "allowed_inbound_cidrs_ssh" {
  type        = list(string)
  description = "List of CIDR blocks to give SSH access to Vault nodes"
  default     = null
}

variable "additional_lb_target_groups"{
  type     = list(string)
  default  = null
}

variable "protocol" {
  default = "HTTPS"
  type    = string
}

variable "route53_zone_id" {
  type = string
  default = ""
}

variable "subdomain" {
  type = string
  default = ""
}
