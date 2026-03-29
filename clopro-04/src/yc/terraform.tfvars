cloud_id  = "b1g4vhp2shscb9od4rnn"
folder_id = "b1g4vhp2shscb9od4rnn"

cidr_public           = ["192.168.10.0/24"]
cidr_public_secondary = ["192.168.11.0/24"]
cidr_public_tertiary  = ["192.168.12.0/24"]

cidr_private_a = ["192.168.20.0/24"]
cidr_private_b = ["192.168.21.0/24"]

cidr_private_app_a = ["192.168.30.0/24"]
cidr_private_app_b = ["192.168.31.0/24"]
cidr_private_app_c = ["192.168.32.0/24"]

k8s_version = "1.31"

db_name      = "netology_db"
db_user_name = "netology_db_user"

backup_window_start = {
  hours   = 23
  minutes = 59
}