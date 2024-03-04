output "lxc" {
  description = "Map of `lxc` resource outputs"
  value = {
    for k, v in module.lxc : k => v.this
  }
}
