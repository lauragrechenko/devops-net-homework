cloud_id  = "b1g4vhp2shscb9od4rnn"
folder_id = "b1g4vhp2shscb9od4rnn"

each_vm = [
  {
    vm_name            = "main",
    cpu                = 2,
    core_fraction      = 5,
    ram                = 1,
    disk_volume        = 6,
    preemptible        = true,
    nat_enabled        = true,
    serial_port_enable = "0"
  },
  {
    vm_name            = "replica",
    cpu                = 2,
    core_fraction      = 5,
    ram                = 2,
    disk_volume        = 5,
    preemptible        = true,
    nat_enabled        = true,
    serial_port_enable = "0"
  },
]