provider "aws" {
  region = "${var.region}"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = "${aws_vpc.my_vpc.id}"
  cidr_block = "10.0.1.0/24"
}

module "mighty_trousers" {
  source      = "./modules/application"
  vpc_id      = "${aws_vpc.my_vpc.id}"
  subnet_id   = "${aws_subnet.public.id}"
  name        = "MightyTrousers"
  environment = "${var.environment}"

  #We will use prod on top level to show that root module variable value will override the default of module itself.
}

output "MODULEHOSTNAME" {
  value = "${module.mighty_trousers.hostname}"
}
