module "test_vpc" {
  source      = "./modules/vpc"
  vpc_name    = var.vpc_name
  subnet_cidr = var.default_cidr
  subnet_zone = var.default_zone
}

module "test_vm" {
  source   = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  for_each = { for vm in var.vm_configs : vm.vm_name => vm }

  env_name       = var.env_name
  network_id     = module.test_vpc.network_id
  subnet_zones   = [var.default_zone]
  subnet_ids     = [module.test_vpc.subnet_id]
  instance_name  = each.value.vm_name
  instance_count = each.value.count
  image_family   = var.vm_image_family
  public_ip      = var.vm_web_nat_enabled

  labels = each.value.labels

  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = var.vm_web_serial_port_enabled
  }
}

data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")

  vars = {
    username       = var.vms_ssh_user
    ssh_public_key = file(local.ssh_pub_key_path)
    packages       = jsonencode(var.cloudinit_packages)
  }
}
