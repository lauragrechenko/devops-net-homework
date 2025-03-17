resource "yandex_iam_service_account" "sa" {
  name        = var.sa_name
  description = var.sa_description
  folder_id   = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_member" "admin-account-iam" {
  folder_id = var.folder_id
  role      = var.iam_member_role
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = var.sa_static_key_description
}