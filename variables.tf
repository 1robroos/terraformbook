variable "region" {
  description = "AWS region. Changing it will lead to loss of complete stack."
  default     = "eu-central-1"
}

variable "environment" {
  default = "prod"
}

variable "allow_ssh_access" {
  description = "List of CIDR blocks that can access instances via SSH"
  default     = ["52.123.123.123/32"]
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  type = "map"

  description = "CIDR blocks for public and private subnets"

  default = {
    public  = "10.0.1.0/24"
    private = "10.0.2.0/24"
  }
}