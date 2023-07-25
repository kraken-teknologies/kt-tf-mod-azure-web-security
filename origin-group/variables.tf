variable "origin_group_name" {
  type = string
}

variable "cdn_frontdoor_profile_id" {
  type = string
}

variable "host_name" {
  type = string
}

variable "tags" {
  type = map(any)
  default = {}
}
variable "path" {
  type = string
  default = "/*"
}