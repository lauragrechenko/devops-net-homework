data "yandex_compute_image" "ubuntu" {
  family = var.vm_image_family
}