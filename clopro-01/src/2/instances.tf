resource "aws_key_pair" "this" {
  key_name   = "${local.name_prefix}-key"
  public_key = local.ssh_pub_key
}

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

resource "aws_instance" "public_vm" {
  ami                    = data.aws_ami.this.id
  instance_type          = var.vm_public_instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.public_ssh_sg.id]
  key_name               = aws_key_pair.this.key_name

  root_block_device {
    volume_type = var.vm_public_volume_type
    volume_size = var.vm_public_volume_size
  }

  tags = {
    Name = "${local.name_prefix}-public-vm"
  }
}

resource "aws_instance" "private_vm" {
  ami                    = data.aws_ami.this.id
  instance_type          = var.vm_private_instance_type
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private_ssh_sg.id]
  key_name               = aws_key_pair.this.key_name

  root_block_device {
    volume_type = var.vm_private_volume_type
    volume_size = var.vm_private_volume_size
  }

  tags = {
    Name = "${local.name_prefix}-private-vm"
  }
}