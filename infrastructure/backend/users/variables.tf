variable "project" {
  description = "Project Name"
}
variable "env" {
  default     = "dev"
  description = "Environment"
}

variable "zoneid" {
  description = "The zone id used to create subdomains"
}
