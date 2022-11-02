output "subdomain" {
	value = aws_route53_record.vault.fqdn
}