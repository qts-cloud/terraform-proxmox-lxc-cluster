variable "config" {
  description = "Configure Cluster Containers"
  type = object({
    # (Required) Provide the hostname prefix. Generated hostnames would be <prefix>-<index>
    hostname_prefix = string

    # (Required) SSH Public Key path stored in the Proxmox CTs
    public_key_path = string

    # (Required) SSH Private Kye path used by the provisioner
    private_key_path = string

    # (Required) Provide required host and optional network configuration.
    targets = list(object({
      host = string
      network = optional(list(object({
        name     = string
        bridge   = optional(string)
        firewall = optional(bool)
        gw       = optional(string)
        gw6      = optional(string)
        hwaddr   = optional(string)
        ip       = optional(string)
        ip6      = optional(string)
        mtu      = optional(string)
        rate     = optional(string)
        tag      = optional(string)
      })))
    }))

    # (Optional) See [lxc](../lxc/README.md) module for possible arguments.
    lxc_config = any
  })
}
