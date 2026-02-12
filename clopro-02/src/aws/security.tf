resource "aws_security_group" "web_sg" {
  name        = "${local.name_prefix}-web-sg"
  description = "Allow HTTP 80 inbound and all outbound"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "${local.name_prefix}-web-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "web_ingress_http" {
  security_group_id = aws_security_group.web_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.web_port
  to_port           = var.web_port
  ip_protocol       = "tcp"

  description = "HTTP inbound"
}

resource "aws_vpc_security_group_egress_rule" "egress_all_ipv4" {
  security_group_id = aws_security_group.web_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  description = "Allow all outbound"
}

# -----------

resource "aws_security_group" "alb_sg" {
  name        = "${local.name_prefix}-alb-sg"
  description = "Allow HTTP inbound to ALB"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "${local.name_prefix}-alb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_ingress_http" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.web_port
  to_port           = var.web_port
  ip_protocol       = "tcp"

  description = "HTTP inbound"
}

resource "aws_vpc_security_group_egress_rule" "alb_egress_all" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  description = "Allow all outbound"
}