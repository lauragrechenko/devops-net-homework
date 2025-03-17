data "vault_generic_secret" "vault_example" {
  path = var.vault_example_path
}

resource "vault_mount" "agent_007" {
  path        = var.vault_agent_path
  type        = var.vault_agent_type
  options     = { version = var.vault_agent_version }
  description = "${var.vault_agent_type} version ${var.vault_agent_version} secret engine mount"
}

resource "vault_kv_secret" "secret" {
  path = "${vault_mount.agent_007.path}/${var.vault_agent_data_path}"

  data_json = jsonencode(var.vault_agent_data)
}
