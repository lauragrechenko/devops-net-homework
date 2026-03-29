resource "yandex_iam_service_account" "k8s_cluster" {
  name = "${local.name_prefix}-k8s-cluster-sa"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s_cluster_agent" {
  folder_id = var.folder_id
  role      = var.k8s_cluster_agent_role
  member    = "serviceAccount:${yandex_iam_service_account.k8s_cluster.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vpc_public_admin" {
  folder_id = var.folder_id
  role      = var.vpc_public_admin_role
  member    = "serviceAccount:${yandex_iam_service_account.k8s_cluster.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "load_balancer_admin" {
  folder_id = var.folder_id
  role      = var.load_balancer_admin_role
  member    = "serviceAccount:${yandex_iam_service_account.k8s_cluster.id}"
}

resource "yandex_iam_service_account" "k8s_node" {
  name = "${local.name_prefix}-k8s-node-sa"
}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             