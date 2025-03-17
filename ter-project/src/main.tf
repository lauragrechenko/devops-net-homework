# VPC & Security groups

module "project_vpc" {
  source = "./modules/vpc"

  vpc_name = var.vpc_name
  env_name = var.vpc_env
  subnets  = var.subnets
}

module "project_security_group" {
  source = "./modules/security"

  name       = var.vpc_security_group_name
  network_id = module.project_vpc.network_id

  security_group_ingress = var.security_group_ingress

  security_group_egress = var.security_group_egress
}




# Web VMs

module "project_vm" {
  source = "./modules/vm"

  vpc_subnet_id      = module.project_vpc.subnet_ids[0]
  security_group_ids = [module.project_security_group.vpc_security_group_id]
  ssh_pub_key        = local.ssh_pub_key
}



# MYSQL

module "project_db_password_secret" {
  source             = "./modules/lockbox_password"
  secret_name        = var.lockbox_secret_name
  secret_description = var.lockbox_secret_description
  iam_member         = var.lockbox_iam_member
  iam_role           = var.lockbox_iam_role
  entry_key          = var.lockbox_entry_key
}

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

data "yandex_lockbox_secret_version" "project_db_password" {
  secret_id = module.project_db_password_secret.secret_id
}

module "project_mysql_db" {
  source     = "./modules/mysql_db"
  cluster_id = module.project_mysql_cluster.cluster_id

  db_name = var.mysql_db_name

  user_name     = var.mysql_db_user_name
  user_password = data.yandex_lockbox_secret_version.project_db_password.entries[0][var.lockbox_entry_key]
}