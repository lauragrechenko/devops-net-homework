YC VMs Role
===========

This role creates Yandex Cloud virtual machines and automatically adds them to Ansible's dynamic inventory.

Requirements
------------

- Yandex Cloud CLI configured with authentication
- `netology_devops.learning` collection installed
- SSH key pair for VM access

Role Variables
--------------

Required variables:
- `yc_folder_id` - Yandex Cloud folder ID
- `yc_subnet_id` - Subnet ID for VMs
- `yc_image_id` - OS image ID (e.g., CentOS, Ubuntu)
- `yc_ssh_key` - Path to public SSH key file

Optional variables (with defaults):
- `yc_zone` - Availability zone (default: "ru-central1-d")
- `yc_ssh_user` - SSH user for connecting to VMs (default: "admin")
- `yc_cores` - CPU cores (default: 2)
- `yc_memory_gb` - RAM in GB (default: 2)
- `yc_disk_gb` - Disk size in GB (default: 10)
- `yc_nat` - Enable public IP (default: true)
- `yc_preemptible` - Use preemptible instances (default: true)

VM list:
- `yc_vms` - List of VMs to create, each with:
  - `name` - VM name (required)
  - `cores` - Override default CPU cores
  - `memory_gb` - Override default RAM
  - Other parameters can also be overridden per VM

Example Playbook
----------------

```yaml
- name: Create VMs
  hosts: localhost
  vars:
    yc_folder_id: "b1g4vhp2shscb9od4rnn"
    yc_subnet_id: "fl8s0thcpg86ati7d5sm"
    yc_image_id: "fd88gogpduub1f9j7lke"
    yc_ssh_key: "{{ lookup('env','HOME') + '/.ssh/id_rsa_yc.pub' }}"
    yc_vms:
      - name: clickhouse
        cores: 2
        memory_gb: 4
      - name: vector
        cores: 2
        memory_gb: 4
  roles:
    - role: yc_vms
```

What It Does
------------

1. Validates required variables
2. Creates VMs in Yandex Cloud
3. Automatically adds created VMs to dynamic inventory with:
   - Host name: `{vm_name}-01`
   - Group: `{vm_name}`
   - Configured SSH access
4. Displays created VM IPs and inventory

After running this role, you can immediately use the created VMs in subsequent plays:

```yaml
- name: Configure Clickhouse
  hosts: clickhouse
  roles:
    - clickhouse
```
