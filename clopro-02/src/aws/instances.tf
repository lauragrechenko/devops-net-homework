data "aws_ami" "this" {
  most_recent = true
  owners      = [var.ami_owner]

  filter {
    name   = "name"
    values = [var.ami_name_filter]
  }

  filter {
    name   = "architecture"
    values = [var.ami_architecture]
  }
}

resource "aws_launch_template" "web" {
  name_prefix   = "${local.name_prefix}-web-"
  image_id      = data.aws_ami.this.id
  instance_type = var.asg_instance_type

  block_device_mappings {
    device_name = var.asg_root_device
    ebs {
      volume_size = var.asg_volume_size
      volume_type = var.asg_volume_type
    }
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.web_sg.id]
  }

  user_data = base64encode(templatefile("./cloud-init.yaml", {
    logo_url = local.pb_logo_url
  }))

  tags = {
    Name = "${local.name_prefix}-web"
  }
}

resource "aws_autoscaling_group" "web" {
  name                = "${local.name_prefix}-web-asg"
  desired_capacity    = var.asg_size
  min_size            = var.asg_size
  max_size            = var.asg_size
  vpc_zone_identifier = [aws_subnet.private.id]
  target_group_arns   = [aws_lb_target_group.web.arn]

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${local.name_prefix}-web"
    propagate_at_launch = true
  }
}