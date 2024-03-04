module "lxc" {
  source = "../lxc"

  for_each = local.lxc
  config   = each.value.config
}

resource "null_resource" "kmsg" {
  for_each = {
    for k, v in module.lxc: k => v.this
  }

  triggers = {
    instance = each.key
  }

  connection {
    type        = "ssh"
    user        = "root"
    password    = ""
    private_key = file(local.private_key_path)
    host        = element(split("/", each.value.network.0.ip), 0)
  }

  provisioner "remote-exec" {
    inline = [
      "echo '#!/bin/sh\nln -s /dev/console /dev/kmsg' > /etc/init.d/kmsg",
      "chmod 755 /etc/init.d/kmsg",
      "/etc/init.d/kmsg"
    ]
  }
}
