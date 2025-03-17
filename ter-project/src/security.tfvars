vpc_security_group_name = "project-security-group"

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