terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}


provider "docker" {
  host = "ssh://remote-docker"
}

resource "random_password" "mysql_pass_root" {
  length = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "mysql_pass_user" {
  length = 16
  special = false
}

resource "docker_container" "mysql8" {
  image = "mysql:8"
  name  = "mysql8-container"

  ports {
    internal = 3306
    external = 3306
  }

  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.mysql_pass_root.result}",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=${random_password.mysql_pass_user.result}",
    "MYSQL_ROOT_HOST=%"
  ]
}
