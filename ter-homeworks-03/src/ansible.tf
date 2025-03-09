resource "local_file" "hosts_templatefile" {
  depends_on = [yandex_compute_instance.web, yandex_compute_instance.db, yandex_compute_instance.storage]

  filename = "${abspath(path.module)}/hosts.ini"
  content = templatefile("${abspath(path.module)}/hosts.tpl", {
    web_servers     = yandex_compute_instance.web,
    db_servers      = yandex_compute_instance.db,
    storage_servers = [yandex_compute_instance.storage]
  })
}