data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    endpoints = {
      s3 = var.s3_endpoint
    }
    bucket                      = var.s3_bucket
    key                         = var.s3_key
    region                      = var.s3_region
    skip_region_validation      = var.skip_region_validation
    skip_credentials_validation = var.skip_credentials_validation
    skip_requesting_account_id  = var.skip_requesting_account_id
    skip_s3_checksum            = var.skip_s3_checksum
    access_key                  = var.access_key
    secret_key                  = var.secret_key
  }
}

module "test_vm" {
  source   = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  for_each = { for vm in var.vm_configs : vm.vm_name => vm }

  env_name       = var.env_name
  network_id     = data.terraform_remote_state.vpc.outputs.network_id
  subnet_zones   = [var.default_zone]
  subnet_ids     = data.terraform_remote_state.vpc.outputs.subnet_ids
  instance_name  = each.value.vm_name
  instance_count = each.value.count
  image_family   = var.vm_image_family
  public_ip      = var.vm_web_nat_enabled

  labels = each.value.labels

  metadata = {
    serial-port-enable = var.vm_web_serial_port_enabled
  }
}