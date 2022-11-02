variable "prefix_name" {}

variable "env" {}

variable "cidr" {}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "common_tags" {
}