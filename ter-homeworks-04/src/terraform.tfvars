cloud_id  = "b1g4vhp2shscb9od4rnn"
folder_id = "b1g4vhp2shscb9od4rnn"

vm_configs = [
  {
    vm_name = "marketing-vm"
    labels = {
      owner   = "i.ivanov"
      project = "marketing"
    }
    count = 1
  },
  {
    vm_name = "analytics-vm"
    labels = {
      owner   = "p.petrov"
      project = "analytics"
    }
    count = 1
  }
]