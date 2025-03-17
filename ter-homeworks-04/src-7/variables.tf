# Vault config vars
variable "vault_addr" {
  type        = string
  default     = "http://127.0.0.1:8200"
  description = "Origin URL of the Vault server. This is a URL with a scheme, a hostname and a port but with no path."
}

variable "vault_example_path" {
  type        = string
  default     = "secret/example"
  description = "Path to Example data"
}

variable "skip_tls_verify" {
  type        = bool
  default     = true
  description = "Set this to true to disable verification of the Vault server's TLS certificate."
}

variable "vault_token" {
  type        = string
  description = "Vault token that will be used by Terraform to authenticate."
}

# Vault data vars
variable "vault_agent_path" {
  type        = string
  default     = "agent"
  description = "The base mount path for the Vault secrets engine."
}

variable "vault_agent_data_path" {
  type        = string
  default     = "007"
  description = "The sub-path for secret data within the mounted Vault secrets engine."
}

variable "vault_agent_data" {
  type        = map(string)
  description = "A map containing the secret data to store in Vault."
}

variable "vault_agent_type" {
  type        = string
  default     = "kv"
  description = "The type of the Vault secrets engine."
}

variable "vault_agent_version" {
  type        = string
  default     = "1"
  description = "The version of the Vault KV secrets engine to use."
}