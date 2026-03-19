resource "aws_lb" "alb" {
  name               = "${local.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public.id, aws_subnet.public_2.id]
  security_groups    = [aws_security_group.alb_sg.id]

  tags = {
    Name        = "${local.name_prefix}-alb"
    Environment = var.env
  }
}

resource "aws_lb_target_group" "web" {
  name     = "${local.name_prefix}-tg"
  port     = var.web_port
  protocol = var.alb_protocol
  vpc_id   = aws_vpc.this.id

  health_check {
    protocol            = var.alb_protocol
    path                = var.alb_healthcheck.path
    healthy_threshold   = var.alb_healthcheck.healthy_threshold
    unhealthy_threshold = var.alb_healthcheck.unhealthy_threshold
    interval            = var.alb_healthcheck.interval
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.web_port
  protocol          = var.alb_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.https_port
  protocol          = var.alb_https_protocol
  ssl_policy        = var.alb_ssl_policy
  certificate_arn   = aws_acm_certificate_validation.website.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}