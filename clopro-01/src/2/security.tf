resource "aws_security_group" "public_ssh_sg" {
  name        = "${local.name_prefix}-allow-ssh"
  description = "Allow SSH inbound and all outbound"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "${local.name_prefix}-allow-ssh"
  }
}

# My current public IP (so SSH isn't open to the whole internet)
data "http" "my_ip" {
  url = var.my_ip_url
}

resource "aws_vpc_security_group_ingress_rule" "ingress_ssh_ipv4" {
  security_group_id = aws_security_group.public_ssh_sg.id
  cidr_ipv4         = local.my_ip_cidr
  from_port         = var.ssh_port
  to_port           = var.ssh_port
  ip_protocol       = "tcp"

  description = "SSH from my public IP"
}

resource "aws_vpc_security_group_egress_rule" "egress_all_ipv4" {
  security_group_id = aws_security_group.public_ssh_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  description = "Allow all outbound"
}



#  --------------------
resource "aws_security_group" "private_ssh_sg" {
  name        = "${local.name_prefix}-allow-ssh-private"
  description = "Allow SSH inbound and all outbound"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "${local.name_prefix}-allow-ssh-private"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_ingress_ssh" {
  security_group_id = aws_security_group.private_ssh_sg.id
  cidr_ipv4         = "${aws_instance.public_vm.private_ip}/32"
  from_port         = var.ssh_port
  to_port           = var.ssh_port
  ip_protocol       = "tcp"

  description = "SSH from public VM only"
}

resource "aws_vpc_security_group_egress_rule" "private_egress_all" {
  security_group_id = aws_security_group.private_ssh_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  description = "Allow all outbound"
}
