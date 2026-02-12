# resource "aws_lb" "nlb" {
#   name               = "${local.name_prefix}-nlb"
#   internal           = false
#   load_balancer_type = "network"
#   subnets            = [aws_subnet.public.id]

#   tags = {
#     Name        = "${local.name_prefix}-nlb"
#     Environment = var.env
#   }
# }

# resource "aws_lb_target_group" "web" {
#   name     = "${local.name_prefix}-tg"
#   port     = var.web_port
#   protocol = "TCP"
#   vpc_id   = aws_vpc.this.id

#   health_check {
#     protocol            = "TCP"
#     healthy_threshold   = var.nlb_healthcheck.healthy_threshold
#     unhealthy_threshold = var.nlb_healthcheck.unhealthy_threshold
#     interval            = var.nlb_healthcheck.interval
#   }
# }

# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.nlb.arn
#   port              = var.web_port
#   protocol          = "TCP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.web.arn
#   }
# }