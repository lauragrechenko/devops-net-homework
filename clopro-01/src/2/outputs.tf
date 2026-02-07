output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "internet_gateway_id" {
  description = "ID of the internet gateway"
  value       = aws_internet_gateway.this.id
}

output "security_group_id" {
  description = "ID of the SSH security group"
  value       = aws_security_group.public_ssh_sg.id
}

output "public_vm_public_ip" {
  description = "Public IP address of the public EC2 instance"
  value       = aws_instance.public_vm.public_ip
}

output "private_vm_private_ip" {
  description = "Private IP address of the private EC2 instance"
  value       = aws_instance.private_vm.private_ip
}
