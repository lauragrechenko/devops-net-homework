locals {
  name_prefix = "${var.project}-${var.env}"
  my_ip_cidr  = "${chomp(data.http.my_ip.response_body)}/32"
  ssh_pub_key = file(var.ssh_pub_key_path)
}