variable "ssh_public_key" {}
variable "ip_address" {}
variable "allow_all_ip_addresses_to_db_server" {}
variable "servers" {
  type = map(any)
  default = {
    frontend = {},
    backend  = {},
    db       = {}
  }
}