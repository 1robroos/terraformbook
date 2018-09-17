variable "environment" {
  default = "dev"
}

variable "instance_type" {
  type = "map"

  default = {
    dev     = "t2.micro"
    test    = "t2.medium"
    prod    = "t2.large"
    sandbox = "t3.micro"
  }
}

variable "vpc_id" {}
variable "subnet_id" {}
variable "name" {}

variable "extra_sgs" {
  default = []
}
