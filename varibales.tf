variable "name-prefix" {
  type        = string
  description = "This variable defines the name prefix for resources"
}

variable "resource_group_name" {
  type         = string
  description = "rg name"
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "Azure region where the resources will be created"
}

# variable "environment" {
#   type        = string
#   description = "This variable defines the environment to be built"
# }

variable "address_space" {
  type        = list(string)
  description = "address space for vnet"
}

variable "address_prefixes" {
  type        = list(string)
  description = "address_prefix for subnet"
}

variable "rules" {

  description = "nsg rules"
  type = list(object({
    name                   = string
    priority               = number
    destination_port_range = number
  }))

  default = [{
    destination_port_range = 22
    name                   = "allow_ssh"
    priority               = 100
    },
    {
      destination_port_range = 80
      name                   = "allow_http"
      priority               = 101
  }]
}

