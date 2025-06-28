variable "virtual_network_name" {
  description = "The name of the virtual network."
  type        = string
  
}
variable "address_space" {
  description = "The address space for the virtual network."
}
variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
  
}
variable "resource_group_location" {
  description = "The location of the resource group."
  type        = string
}
