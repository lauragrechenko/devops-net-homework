provider "vault" {
  address         = var.vault_addr
  skip_tls_verify = var.skip_tls_verify
  token           = var.vault_token
}