locals {
  vault_user_data = templatefile("${path.module}/templates/install_vault.sh.tpl",
    {
      region                = var.aws_region
      name                  = var.prefix_name
      vault_version         = var.vault_version
      kms_key_arn           = var.kms_key_arn
      secrets_manager_arn   = var.secrets_manager_arn
      leader_tls_servername = var.leader_tls_servername
    }
  )
}