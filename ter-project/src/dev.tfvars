lockbox_db_secret_name        = "project_lockbox_secret"
lockbox_db_secret_description = "Lockbox Secret for DB password"
lockbox_db_service_account_id = "ajeu15gq2a3vprdqer38"
lockbox_db_entry_key          = "mysql_db_password"

registry_service_account_id = "ajeu15gq2a3vprdqer38"
service_account_id          = "ajeu15gq2a3vprdqer38"

mysql_cluster_name = "terraform_modulle_project_cluster"
mysql_db_name      = "terraform_module_project_db"
mysql_db_user_name = "developer"


vpc_subnets = [{ zone = "ru-central1-a", cidr = ["10.0.1.0/24"] }]
vpc_name    = "s3-test-vpc"

security_group_name = "project-security-group"
security_group_ingress = [
  {
    protocol       = "TCP"
    description    = "разрешить входящий ssh"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  },
  {
    protocol       = "TCP"
    description    = "разрешить входящий  http"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  },
  {
    protocol       = "TCP"
    description    = "разрешить входящий  http, python web app"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 8090
  },
  {
    protocol       = "TCP"
    description    = "разрешить входящий https"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  },
]

security_group_egress = [
  {
    protocol       = "TCP"
    description    = "разрешить весь исходящий трафик"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65365
  }
]