resource "aws_lb" "alb" {
  name               = "${local.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public.id, aws_subnet.public_2.id]
  security_groups    = []

  tags = {
    Name        = "${local.name_prefix}-alb"
    Environment = var.env
  }
}

resource "aws_lb_target_group" "web" {
  name     = "${local.name_prefix}-tg"
  port     = var.web_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.this.id

  health_check {
    protocol            = "HTTP"
    healthy_threshold   = var.alb_healthcheck.healthy_threshold
    unhealthy_threshold = var.alb_healthcheck.unhealthy_threshold
    interval            = var.alb_healthcheck.interval
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.web_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}