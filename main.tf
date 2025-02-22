module "lxc" {
  source = "git::https://github.com/qts-cloud/terraform-proxmox-lxc.git?ref=v1.1.0"

  for_each = local.lxc
  config   = each.value.config
}

resource "null_resource" "configure" {
  for_each = {
    for k, v in module.lxc : k => v.info
  }

  triggers = {
    instance = each.key
  }

  connection {
    type        = "ssh"
    user        = "root"
    password    = ""
    private_key = local.private_key
    host        = each.value.host
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Configuring ${each.key}'...",
      # Extract LXC ID
      "LXC_ID=${each.value.id}",
      "echo \"LXC ID: $LXC_ID\"",

      "echo 'Performing host-level configurations...'",
      "echo 'lxc.apparmor.profile: unconfined' >> /etc/pve/lxc/$LXC_ID.conf",
      "echo 'lxc.cgroup2.devices.allow: a' >> /etc/pve/lxc/$LXC_ID.conf",
      "echo 'lxc.cap.drop:' >> /etc/pve/lxc/$LXC_ID.conf",
      "echo 'lxc.mount.auto: \"proc:rw sys:rw\"' >> /etc/pve/lxc/$LXC_ID.conf",

      "echo 'Running commands inside LXC container $LXC_ID...'",
      "echo 'Configuring /dev/kmsg...'",
      "pct exec $LXC_ID -- bash -c \"echo '[Unit]\nDescription=Create /dev/kmsg symlink\n\n[Service]\nType=oneshot\nExecStart=/bin/ln -sf /dev/console /dev/kmsg\nRemainAfterExit=yes\n\n[Install]\nWantedBy=multi-user.target' > /etc/systemd/system/kmsg.service\"",
      "pct exec $LXC_ID -- bash -c 'systemctl enable kmsg.service'",
      "pct stop $LXC_ID",
      "sleep 3",
      "pct start $LXC_ID",
    ]
  }
}
