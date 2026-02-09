```
                    ┌─────────────────┐
                    │    Internet     │
                    └────────┬────────┘
                             │
                    ┌────────┴────────┐
                    │  ALB Listener   │
                    │  :80 (HTTP)     │
                    └────────┬────────┘
                             │
                    ┌────────┴────────┐
                    │  HTTP Router    │
                    └────────┬────────┘
                             │
                    ┌────────┴────────┐
                    │  Virtual Host   │
                    │  authority: "*" │
                    │  route: "/*"    │
                    └────────┬────────┘
                             │
                    ┌────────┴────────┐
                    │  Backend Group  │
                    │  healthcheck:   │
                    │  HTTP :80 /     │
                    └────────┬────────┘
                             │
                    ┌────────┴────────┐
                    │  Target Group   │
                    │  (auto-managed  │
                    │   by IG)        │
                    └───┬────┬────┬───┘
                        │    │    │
                   ┌────┘    │    └────┐
                   ▼         ▼         ▼
              ┌─────────┐┌─────────┐┌─────────┐
              │  VM-1   ││  VM-2   ││  VM-3   │
              │ LAMP:80 ││ LAMP:80 ││ LAMP:80 │
              └─────────┘└─────────┘└─────────┘
                   Instance Group (3 VMs)



Internet
  │
  ▼
ALB (yandex_alb_load_balancer.alb)  ──listener:8080──▶  Router (yandex_alb_http_router.alb_router)
                                                    │
                                                    ▼
                                           Virtual Host (yandex_alb_virtual_host.my-vhost)
                                           (правила host/path → route)
                                                    │
                                                    ▼
                                       Backend Group (yandex_alb_backend_group.alb_backend_group)
                                       (какие бэкенды, healthcheck, LB-настройки)
                                                    │
                                                    ▼
                               Target Group (yandex_alb_target_group.…)
                               (список конкретных endpoint’ов: ВМ/IP из твоей IG)
                                                    │
                                                    ▼
                                            VMs (LAMP)


┌──────────────────────────────────────────────────────────────┐
│                     Internet / Client                        │
└───────────────────────────────┬──────────────────────────────┘
                                │
                                ▼
┌──────────────────────────────────────────────────────────────┐
│  Application Load Balancer (ALB)                              │
│  yandex_alb_load_balancer.alb                                 │
│                                                              │
│  External IPv4                                                │
│  Listener: HTTP :8080                                         │
│                                                              │
│  listener.http.handler                                        │
│        └── http_router_id                                     │
│                                                              │
└───────────────────────────────┬──────────────────────────────┘
                                │
                                ▼
┌──────────────────────────────────────────────────────────────┐
│  HTTP Router                                                  │
│  yandex_alb_http_router.alb_router                            │
│                                                              │
│  (L7 routing table: hosts / paths)                            │
│                                                              │
└───────────────────────────────┬──────────────────────────────┘
                                │
                                ▼
┌──────────────────────────────────────────────────────────────┐
│  Virtual Host                                                 │
│  yandex_alb_virtual_host.my-vhost                             │
│                                                              │
│  Route: "/" (or default)                                     │
│                                                              │
│  route.http_route.http_route_action                           │
│        └── backend_group_id                                   │
│                                                              │
└───────────────────────────────┬──────────────────────────────┘
                                │
                                ▼
┌──────────────────────────────────────────────────────────────┐
│  Backend Group                                                │
│  yandex_alb_backend_group.alb_backend_group                  │
│                                                              │
│  http_backend                                                 │
│    • port: 80  (обычно)                                       │
│    • healthcheck: HTTP GET /                                  │
│    • load balancing config                                   │
│                                                              │
│  target_group_ids                                             │
│        └── target group                                       │
│                                                              │
└───────────────────────────────┬──────────────────────────────┘
                                │
                                ▼
┌──────────────────────────────────────────────────────────────┐
│  Target Group                                                 │
│  yandex_alb_target_group.*                                    │
│                                                              │
│  Targets:                                                     │
│    • VM #1 (private IP)                                       │
│    • VM #2 (private IP)                                       │
│    • VM #3 (private IP)                                       │
│                                                              │
└───────────────────────────────┬──────────────────────────────┘
                                │
                                ▼
┌──────────────────────────────────────────────────────────────┐
│  Instance Group                                               │
│  LAMP VMs                                                     │
│  Apache :80                                                   │
│  user-data → index.html + image from bucket                   │
└──────────────────────────────────────────────────────────────┘                                           
```                   