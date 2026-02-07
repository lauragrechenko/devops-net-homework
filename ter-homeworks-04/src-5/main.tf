module "test_vpc" {
  source   = "./modules/vpc"
  env_name = var.env_name
  vpc_name = var.vpc_name
  subnets = [
    {
      zone = var.default_zone,
      cidr = var.default_cidr
    },
    {
      zone = var.zone_b,
      cidr = var.cidr_2
    }
  ]
}


module "test_cluster" {
  source   = "./modules/mysql_cluster"
  env_name = var.mysql_env

  ha              = var.mysql_ha_available
  cluster_name    = var.mysql_cluster_name
  cluster_version = var.mysql_cluster_version

  network_id = module.test_vpc.network_id

  resources_preset_id    = var.mysql_cluster_resources_preset_id
  resources_disk_type_id = var.mysql_cluster_resources_disk_type_id
  resources_disk_size    = var.mysql_cluster_resources_disk_size

  host_configs = [
    {
      zone      = var.default_zone
      subnet_id = module.test_vpc.subnet_ids[0]
    },
    {
      zone      = var.zone_b
      subnet_id = module.test_vpc.subnet_ids[1]
    }
  ]
}

module "test_db" {
  source     = "./modules/mysql_db"
  cluster_id = module.test_cluster.cluster_id

  db_name = var.mysql_db_name

  user_name     = var.mysql_db_user_name
  user_password = var.mysql_db_user_password
}