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

```
                     Internet
                        │
         ┌──────────────┴──────────────┐
         │     VPC 10.10.0.0/16        │
         │         ┌─────┐             │
         │         │ IGW │             │
         │         └──┬──┘             │
         │            │                │
         │  ┌─────────┴─────────────┐  │
         │  │ Public 10.10.1.0/24   │  │
         │  │ RT: 0.0.0.0/0 → IGW   │  │
         │  │                       │  │
         │  │  ┌──────┐  ┌───────┐  │  │
         │  │  │ ALB  │  │  NAT  │  │  │
         │  │  │ :80  │  │  GW   │  │  │
         │  │  └──┬───┘  └───┬───┘  │  │
         │  └─────┼──────────┼──────┘  │
         │        │          │         │
         │  ┌─────┼──────────┼──────┐  │
         │  │Private 10.10.2.0/24   │  │
         │  │ RT: 0.0.0.0/0 → NAT GW│  │
         │  │     │          │      │  │
         │  │     ▼          │      │  │
         │  │  ┌──────┐      │      │  │
         │  │  │EC2 x3│──────┘      │  │
         │  │  │(ASG) │ outbound    │  │
         │  │  └──────┘             │  │
         │  └───────────────────────┘  │
         └─────────────────────────────┘
```

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              INTERNET                                       │
└───────────────────────────────┬─────────────────────────────────────────────┘
                                │
                    ┌───────────┴──────────┐
                    │  User HTTP request   │
                    └───────────┬──────────┘
                                │
┌───────────────────────────────┼──────────────────────────────────────────────┐
│                    VPC 10.10.0.0/16                                          │
│                               │                                              │
│                    ┌──────────▼───────────┐                                  │
│                    │   Internet Gateway   │                                  │
│                    │    (IGW)             │                                  │
│                    └──────────┬───────────┘                                  │
│                               │                                              │
│  ┌────────────────────────────┼─────────────────────────────────────────┐    │
│  │        PUBLIC SUBNET 10.10.1.0/24                                    │    │
│  │                            │                                         │    │
│  │  Route Table (public-rt):  │                                         │    │
│  │  ┌──────────────────────┐  │                                         │    │
│  │  │ 10.10.0.0/16 → local │  │                                         │    │
│  │  │ 0.0.0.0/0 → IGW      │  │                                         │    │
│  │  └──────────────────────┘  │                                         │    │
│  │                            │                                         │    │
│  │         ┌──────────────────┼────────────┐                            │    │
│  │         │       NLB        │            │                            │    │
│  │         │   :80 (TCP)      │            │                            │    │
│  │         │  External IP     │            │                            │    │
│  │         │  158.160.x.x     │            │                            │    │
│  │         └──────────────────┼────────────┘                            │    │
│  │         (no SG - L4 LB)    │                                         │    │
│  │                            │                                         │    │
│  │                   ┌────────▼─────────┐       ┌──────────────┐        │    │
│  │                   │  Target Group    │       │  NAT Gateway │        │    │
│  │                   │  :80 TCP         │       │  EIP:        │        │    │
│  │                   │  Healthcheck:    │       │  3.73.176.79 │        │    │
│  │                   │  TCP every 30s   │       │              │        │    │
│  │                   └────────┬─────────┘       └──────┬───────┘        │    │
│  └─────────────────────────────────────────────────────┼────────────────┘    │
│                               │                        │                     │
│                               │         ┌──────────────┘                     │
│  ┌────────────────────────────┼─────────┼───────────────────────────────┐    │
│  │      PRIVATE SUBNET 10.10.2.0/24     │                               │    │
│  │                            │         │                               │    │
│  │  Route Table (private-rt): │         │                               │    │
│  │  ┌──────────────────────┐  │         │                               │    │
│  │  │ 10.10.0.0/16 → local │  │         │                               │    │
│  │  │ 0.0.0.0/0 → NAT GW   │◄─┼─────────┘ (outbound only)               │    │
│  │  └──────────────────────┘  │                                         │    │
│  │                            │                                         │    │
│  │                   ┌────────▼──────────────────────┐                  │    │
│  │                   │  EC2 Instances (ASG x3)       │                  │    │
│  │                   │  ┌─────────────────────────┐  │                  │    │
│  │                   │  │ Instance 1: 10.10.2.105 │  │                  │    │
│  │                   │  │ Instance 2: 10.10.2.183 │  │                  │    │
│  │                   │  │ Instance 3: 10.10.2.246 │  │                  │    │
│  │                   │  └─────────────────────────┘  │                  │    │
│  │                   │                                │                  │    │
│  │                   │  Security Group: web_sg        │                  │    │
│  │                   │  ┌──────────────────────────┐  │                  │    │
│  │                   │  │ INGRESS:                 │  │                  │    │
│  │                   │  │  TCP 80 ← 0.0.0.0/0      │  │ (from NLB)       │    │
│  │                   │  │                          │  │                  │    │
│  │                   │  │ EGRESS:                  │  │                  │    │
│  │                   │  │  ALL → 0.0.0.0/0         │  │ (for apt, etc)   │    │
│  │                   │  └──────────────────────────┘  │                  │    │
│  │                   │                                │                  │    │
│  │                   │  Apache :80                    │                  │    │
│  │                   │  index.html → S3 image URL     │                  │    │
│  │                   └────────────────────────────────┘                  │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
└──────────────────────────────────────────────────────────────────────────────┘

                         ┌───────────────────────┐
                         │    S3 Bucket          │
                         │  pb-logo.png          │
                         │  (public read)        │
                         └───────────────────────┘

TRAFFIC FLOWS:

1. USER → NLB
   ✓ Route: Internet → IGW → NLB (public subnet)
   ✓ No SG check (NLB operates at L4)

2. NLB → EC2
   ✓ NLB forwards to Target Group targets
   ✓ Route: Public subnet → Private subnet (same VPC, route table: local)
   ✓ SG check: web_sg allows TCP 80 from 0.0.0.0/0 ✓

3. EC2 → Internet (apt install)
   ✓ Route: Private RT → NAT GW (in public subnet) → IGW → Internet
   ✓ SG check: web_sg allows all egress ✓
   ✓ NAT translates source IP to EIP 3.73.176.79

4. Browser → S3 (image fetch)
   ✓ Direct HTTPS connection (not through EC2/NLB)
   ✓ S3 bucket policy allows public GetObject

KEY POINTS:
- Route Tables: Define paths (where traffic goes)
- Security Groups: Define firewall rules (what traffic is allowed)
- NLB: No SG, passes traffic directly to EC2 (EC2's SG filters it)
- NAT GW: Enables private instances to reach internet (outbound only)

```

```
                          Internet
                             │
         ┌───────────────────┴─────────────────────────────┐
         │              VPC 10.10.0.0/16                   │
         │                   ┌─────┐                       │
         │                   │ IGW │                       │
         │                   └──┬──┘                       │
         │                      │                          │
         │  ┌───────────────────┼────────────────────────┐ │
         │  │         PUBLIC SUBNETS                     │ │
         │  │                   │                        │ │
         │  │  ┌────────────────┴─────────────────────┐  │ │
         │  │  │              ALB                     │  │ │
         │  │  │  SG: alb_sg (HTTP 80 ← 0.0.0.0/0)    │  │ │
         │  │  │  DNS: clopro-dev-alb-xxx.elb...      │  │ │
         │  │  └────────────────┬─────────────────────┘  │ │
         │  │                   │                        │ │
         │  │  eu-central-1a    │       eu-central-1b    │ │
         │  │  10.10.1.0/24     │       10.10.3.0/24     │ │
         │  │  ┌────────────┐   │   ┌────────────────┐   │ │
         │  │  │ public     │   │   │ public_2       │   │ │
         │  │  │            │   │   │                │   │ │
         │  │  │  NAT GW    │   │   │  (ALB node)    │   │ │
         │  │  │  EIP: x.x  │   │   │                │   │ │
         │  │  └─────┬──────┘   │   └────────────────┘   │ │
         │  │        │          │                        │ │
         │  │  RT: 0.0.0.0/0 → IGW (both subnets)        │ │
         │  └────────┼──────────┼────────────────────────┘ │
         │           │          │                          │
         │           │          ▼                          │
         │           │   ┌─────────────┐                   │
         │           │   │ Target Group│                   │
         │           │   │ HTTP :80    │                   │
         │           │   │ HC: GET /   │                   │
         │           │   └──────┬──────┘                   │
         │           │          │                          │
         │  ┌────────┼──────────┼───────────────────────┐  │
         │  │  PRIVATE SUBNET   │      eu-central-1a    │  │
         │  │  10.10.2.0/24     │                       │  │
         │  │  RT: 0.0.0.0/0 → NAT GW                   │  │
         │  │                   │                       │  │
         │  │        ┌──────────▼──────────┐            │  │
         │  │        │   ASG (3x EC2)      │            │  │
         │  │        │   t3.micro          │            │  │
         │  │        │                     │            │  │
         │  │        │  10.10.2.x          │            │  │
         │  │        │  10.10.2.y ─────────┼─→ NAT GW   │  │
         │  │        │  10.10.2.z          │ (outbound) │  │
         │  │        │                     │            │  │
         │  │        │  SG: web_sg         │            │  │
         │  │        │  IN:  TCP 80        │            │  │
         │  │        │  OUT: all           │            │  │
         │  │        │                     │            │  │
         │  │        │  Apache :80         │            │  │
         │  │        │  <img src="S3 URL"> │            │  │
         │  │        └─────────────────────┘            │  │
         │  └───────────────────────────────────────────┘  │
         └─────────────────────────────────────────────────┘

                    ┌───────────────────┐
                    │    S3 Bucket      │
                    │    pb-logo.png    │
                    └───────────────────┘

Key difference from NLB:
┌──────────────────────┬──────────────────────┐
│        NLB           │         ALB          │
├──────────────────────┼──────────────────────┤
│ L4 (TCP)             │ L7 (HTTP)            │
│ 1 subnet / 1 AZ     │ 2 subnets / 2 AZs   │
│ No security group    │ Has own SG (alb_sg)  │
│ Passes traffic as-is │ Terminates HTTP      │
│ TCP health check     │ HTTP health check    │
│                      │ (GET / on path)      │
└──────────────────────┴──────────────────────┘
```