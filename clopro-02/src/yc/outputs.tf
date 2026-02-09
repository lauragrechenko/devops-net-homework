output "pb_logo_url" {
  value = local.pb_logo_url
}

output "ig_service_account_id" {
  value = yandex_iam_service_account.ig_account.id
}

output "ig_instance_group_id" {
  value = yandex_compute_instance_group.vms_ig.id
}

output "ig_instances" {
  value = yandex_compute_instance_group.vms_ig.instances[*].network_interface[0].nat_ip_address
}

output "nlb_address" {
  value = [for l in yandex_lb_network_load_balancer.nlb.listener : one(l.external_address_spec).address]
}

# output "alb_external_ip" {
#   value = yandex_alb_load_balancer.alb.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
# }