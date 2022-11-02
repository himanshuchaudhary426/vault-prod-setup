resource "aws_security_group" "vault_lb" {
  description = "Security group for the application load balancer"
  name        = "${var.prefix_name}-vault-lb-sg"
  vpc_id      = var.vpc_id

  tags = merge(
    { Name = "${var.prefix_name}-vault-lb-sg" },
    var.common_tags,
  )
}

resource "aws_security_group_rule" "vault_lb_inbound" {
  count             = var.allowed_inbound_cidrs != null ? 1 : 0
  description       = "Allow specified CIDRs access to load balancer on port 8200"
  security_group_id = aws_security_group.vault_lb.id
  type              = "ingress"
  from_port         = 8200
  to_port           = 8200
  protocol          = "tcp"
  cidr_blocks       = var.allowed_inbound_cidrs
}

resource "aws_security_group_rule" "vault_lb_outbound" {
  description              = "Allow outbound traffic from load balancer to Vault nodes on port 8200"
  security_group_id        = aws_security_group.vault_lb.id
  type                     = "egress"
  from_port                = 8200
  to_port                  = 8200
  protocol                 = "tcp"
  source_security_group_id = var.vault_sg_id
}

resource "aws_lb" "vault_lb" {
  name                       = "${var.prefix_name}-vault-lb"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = [var.public-subnet-1, var.public-subnet-2, var.public-subnet-3]
  security_groups            = [aws_security_group.vault_lb.id]
  drop_invalid_header_fields = true

  tags = merge(
    { Name = "${var.prefix_name}-vault-lb" },
    var.common_tags,
  )
}

resource "aws_lb_target_group" "vault" {
  name                 = "${var.prefix_name}-vault-tg"
  deregistration_delay = var.lb_deregistration_delay
  target_type          = "instance"
  port                 = 8200
  protocol             = var.protocol
  vpc_id               = var.vpc_id

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    protocol            = var.protocol
    port                = "traffic-port"
    path                = var.lb_health_check_path
    interval            = 30
  }

  tags = merge(
    { Name = "${var.prefix_name}-vault-tg" },
    var.common_tags,
  )
}

resource "aws_lb_listener" "vault-https" {
  count             = var.protocol == "HTTPS" ? 1 : 0
  load_balancer_arn = aws_lb.vault_lb.id
  port              = 8200
  protocol          = var.protocol
  ssl_policy        = var.ssl_policy 
  certificate_arn   = var.lb_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vault.arn
  }
}

resource "aws_lb_listener" "vault-http" {
  count             = var.protocol == "HTTP" ? 1 : 0
  load_balancer_arn = aws_lb.vault_lb.id
  port              = 8200
  protocol          = var.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vault.arn
  }
}