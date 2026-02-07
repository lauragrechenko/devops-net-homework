locals {
  name_prefix = "${var.project}-${var.env}"
  ssh_pub_key = file("${var.ssh_pub_key_path}")
}