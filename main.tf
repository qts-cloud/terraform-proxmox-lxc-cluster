module "lxc" {
  source  = "app.terraform.io/qts/lxc/proxmox"
  version = "1.0.0"

  for_each = local.lxc
  config   = each.value.config
}

resource "null_resource" "kmsg" {
  for_each = {
    for k, v in module.lxc : k => v.this
  }

  triggers = {
    instance = each.key
  }

  connection {
    type        = "ssh"
    user        = "root"
    password    = ""
    private_key = local.private_key
    host        = element(split("/", each.value.network.0.ip), 0)
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Configuring /dev/kmsg'...",
      "echo -e '[Unit]\nDescription=Create /dev/kmsg symlink\n\n[Service]\nType=oneshot\nExecStart=/bin/ln -sf /dev/console /dev/kmsg\nRemainAfterExit=yes\n\n[Install]\nWantedBy=multi-user.target' > /etc/systemd/system/kmsg.service",
      "systemctl enable kmsg.service",
      "systemctl start kmsg.service"
    ]
  }
}
