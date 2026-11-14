variable "rg_name" {
  type        = string
  description = "Resource group name"
}
variable "suffix" {
  type        = string
  description = "Short unique suffix (lowercase letters and digits)"
}
variable "location" {
  type    = string
  default = "swedencentral"
}
variable "public_blob_access" {
  type    = bool
  default = false
}
variable "environment_tag" {
  type    = string
  default = "test"
}
locals {
  tags = var.environment_tag == "none" ? { owner = "infraorcinus-test" } : { Environment = var.environment_tag, owner = "infraorcinus-test", purpose = "e2e-pr" }
}
variable "public_network_access" {
  type    = bool
  default = false
}
