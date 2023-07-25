variable "name" {
  type = string
  description = "Name for Front Door deployment"
}

variable "sku_name" {
  type = string
  default = "Standard_AzureFrontDoor"
}

variable "resource_group_name" {
  type = string
}
variable "tags" {
  type = map(any)
  default = {}
}