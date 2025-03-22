# VPC & Security groups

module "project_vpc" {
  source = "./modules/vpc"

  vpc_name = var.vpc_name
  env_name = var.vpc_env
  subnets  = var.vpc_subnets
}

module "project_security_group" {
  source = "./modules/security"

  name       = var.security_group_name
  network_id = module.project_vpc.network_id

  security_group_ingress = var.security_group_ingress

  security_group_egress = var.security_group_egress
}


# Repo registry

module "project_registry" {
  source = "./modules/container_registry"

  service_account_id = var.registry_service_account_id
}

# Web VMs

module "project_vm" {
  source = "./modules/vm"

  vpc_subnet_id      = module.project_vpc.subnet_ids[0]
  security_group_ids = [module.project_security_group.vpc_security_group_id]

  container_registry_id = module.project_registry.container_registry_id

  vm_metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = var.vm_web_serial_port_enabled
  }

  service_account_id = var.service_account_id
}

data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")

  vars = {
    username       = var.vms_ssh_user
    ssh_public_key = file(local.ssh_pub_key_path)
    packages       = jsonencode(var.vm_web_cloudinit_packages)

    db_host               = module.project_mysql_cluster.db_host_fqdns[0]
    db_user               = module.project_mysql_db.user_name
    db_password_secret_id = module.project_db_password_secret.secret_id
    db_name               = var.mysql_db_name
  }
}


# MYSQL

module "project_mysql_cluster" {
  source = "./modules/mysql_cluster"

  cluster_name = var.mysql_cluster_name
  network_id   = module.project_vpc.network_id
  host_configs = [
    {
      zone      = var.default_zone
      subnet_id = module.project_vpc.subnet_ids[0]
    }
  ]
}

module "project_db_password_secret" {
  source = "./modules/lockbox_password"

  secret_name        = var.lockbox_db_secret_name
  secret_description = var.lockbox_db_secret_description
  entry_key          = var.lockbox_db_entry_key

  service_account_id = var.lockbox_db_service_account_id
}

data "yandex_lockbox_secret_version" "project_db_password" {
  secret_id = module.project_db_password_secret.secret_id
}

module "project_mysql_db" {
  source     = "./modules/mysql_db"
  cluster_id = module.project_mysql_cluster.cluster_id

  db_name = var.mysql_db_name

  user_name = var.mysql_db_user_name
  user_password = [for entry in data.yandex_lockbox_secret_version.project_db_password.entries : entry.text_value if entry.key == var.lockbox_db_entry_key][0]
}


### DNS

resource "yandex_dns_zone" "zone1" {
  name             = var.dns_zone_name
  description      = var.dns_zone_description
  zone             = var.domain_zone
  public           = var.dns_zone_public
  private_networks = [module.project_vpc.network_id]
}

resource "yandex_dns_recordset" "rs1" {
  zone_id = yandex_dns_zone.zone1.id
  name    = var.dns_record_name
  type    = var.dns_record_type
  ttl     = var.dns_record_ttl
  data    = [module.project_vm.vm_instances_info[0].ip]
}