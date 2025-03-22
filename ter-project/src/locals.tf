locals {
  ssh_pub_key      = file("~/.ssh/id_rsa.pub")
  ssh_pub_key_path = "~/.ssh/id_rsa.pub"
}