variable "project" {
  description = "Project Name"
}
variable "env" {
  default     = "dev"
  description = "Environment"
}
variable "fqdn" {
  description = "This FQDN will be used to create subzones"
}
