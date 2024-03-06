locals {
  hostname_prefix = try(coalesce(var.config.hostname_prefix), null)
  public_key      = sensitive(try(coalesce(var.config.public_key), null))
  private_key     = sensitive(try(coalesce(var.config.private_key), null))
  targets         = try(coalesce(var.config.targets), [])
  lxc_config      = try(coalesce(var.config.lxc_config), {})

  lxc = {
    for i, target in local.targets :
    "${local.hostname_prefix}-${i + 1}" => {
      config = merge(
        local.lxc_config,
        {
          hostname        = "${local.hostname_prefix}-${i + 1}"
          target_node     = target.host
          network         = concat(try(local.lxc_config.network, []), try(target.network, []))
          ssh_public_keys = local.public_key
        }
      )
    }
  }
}
