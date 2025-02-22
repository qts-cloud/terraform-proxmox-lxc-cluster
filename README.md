# terraform-proxmox-lxc-cluster
Create an LXC Cluster

<!-- BEGIN_TF_DOCS -->
[![semantic-release-badge]][semantic-release]

## Usage

Basic usage of this module:

---
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | 3.0.1-rc4 |
## Resources

| Name | Type |
|------|------|
| [null_resource.configure](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_config"></a> [config](#input\_config) | Configure Cluster Containers | <pre>object({<br/>    # (Required) Provide the hostname prefix. Generated hostnames would be <prefix>-<index><br/>    hostname_prefix = string<br/><br/>    # (Required) SSH Public Key<br/>    public_key = string<br/><br/>    # (Required) SSH Private Key<br/>    private_key = string<br/><br/>    # (Required) Provide required host and optional network configuration.<br/>    targets = list(object({<br/>      host = string<br/>      network = optional(list(object({<br/>        name     = string<br/>        bridge   = optional(string)<br/>        firewall = optional(bool)<br/>        gw       = optional(string)<br/>        gw6      = optional(string)<br/>        hwaddr   = optional(string)<br/>        ip       = optional(string)<br/>        ip6      = optional(string)<br/>        mtu      = optional(string)<br/>        rate     = optional(string)<br/>        tag      = optional(string)<br/>      })))<br/>    }))<br/><br/>    # (Optional) See [lxc](../lxc/README.md) module for possible arguments.<br/>    lxc_config = any<br/>  })</pre> | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lxc"></a> [lxc](#output\_lxc) | Map of `lxc` resource outputs |
---
[semantic-release-badge]: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
[conventional-commits]: https://www.conventionalcommits.org/
[semantic-release]: https://semantic-release.gitbook.io
[semantic-release-badge]: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
[vscode-conventional-commits]: https://marketplace.visualstudio.com/items?itemName=vivaxy.vscode-conventional-commits
<!-- END_TF_DOCS -->