variable "cidr" {
  default = "10.0.0.0/16"
}

variable "Availability_zones" {
    type = list(string)
    description = "Availability Zones"
    default = ["us-east-1a", "us-east-1b"]
}
