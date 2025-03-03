locals {
  vm_web_instance_name = "netology-${var.vpc_name}-${var.vm_web_instance_sufix}"
  vm_db_instance_name  = "netology-${var.vpc_name}-${var.vm_db_instance_sufix}"
}