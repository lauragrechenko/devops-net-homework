resource "local_file" "hosts_templatefile" {
  depends_on = [yandex_compute_instance.web, yandex_compute_instance.db, yandex_compute_instance.storage]

  filename = "${abspath(path.module)}/hosts.ini"
  content = templatefile("${abspath(path.module)}/hosts.tpl", {
    web_servers     = yandex_compute_instance.web,
    db_servers      = yandex_compute_instance.db,
    storage_servers = [yandex_compute_instance.storage]
  })
}

resource "null_resource" "hosts_provision" {
  depends_on = [
    local_file.hosts_templatefile
  ]

  provisioner "local-exec" {
    command    = "eval $(ssh-agent) && cat ~/.ssh/id_ed25519 | ssh-add -"
    on_failure = continue
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${local_file.hosts_templatefile.filename} ${abspath(path.module)}/playbook.yml"

    on_failure  = continue
    environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }
  }
  triggers = {
    always_run      = "${timestamp()}" #всегда т.к. дата и время постоянно изменяются
    always_run_uuid = "${uuid()}"
  }
}
