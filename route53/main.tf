resource "aws_route53_record" "vault" {
  zone_id = var.route53_zone_id
  name    = var.subdomain
  type    = "A"

  alias {
    name = var.elb_dns_name
    zone_id = var.elb_zone_id
    evaluate_target_health = true
  }
}