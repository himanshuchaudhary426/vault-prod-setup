# HA Prod Vault Setup on AWS using terraform


## Prerequisites

### 1. First add all the required variables in variables.tf
### 2. Create self-signed SAN certificates using openssl or from any tool.
### 3. Import your self signed certificates to your Certificate manager in AWS.
### 4. Store your self signed certificate in the secret manager to inject them at the time of vault installation in the servers.
### 5. Create the following secret in secret manager in the base64 encoded value.
  		vault_cert = certificate to use with vault
  		vault_ca   = vault certificate authority from which you have created the self-signed certificate.
  		vault_pk   = Private key of the certificate.

## Terraform steps

### 1. Initialize the terraform

	terraform init

### 2. Plan the infrastructure using terraform.

	terraform plan

### 3. Apply the terraform to provision all the resources in AWS.

	terraform apply

### After all the infrastructure setup, SSH in one of the node using AWS SSM form the console and run following command.

	vault operator init

### After initilazing the vault, it will store all the keys in KMS, also you need to backup all the keys and token in some safe place.

### Check all the nodes are connected the cluster using the below command.

	vault operator raft list-peers