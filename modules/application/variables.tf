variable "environment" {
  default = "dev"
}

variable "instance_type" {
  type = "map"

  default = {
    dev     = "t2.micro"
    test    = "t2.micro"
    prod    = "t2.medium"
    sandbox = "t2.micro"
  }
}

variable "vpc_id" {}
variable "subnet_id" {}
variable "name" {}

variable "extra_sgs" {
  default = []
}
