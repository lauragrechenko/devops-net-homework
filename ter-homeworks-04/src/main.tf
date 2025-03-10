resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

module "test-vm" {
  source   = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  for_each = { for vm in var.vm_configs : vm.vm_name => vm }

  env_name       = var.env_name
  network_id     = yandex_vpc_network.develop.id
  subnet_zones   = [var.default_zone]
  subnet_ids     = [yandex_vpc_subnet.develop.id]
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
