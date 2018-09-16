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
  extra_sgs   = ["${aws_security_group.default.id}"] #pass xtra SG  to the module, wrapping it with square brackets 

  #We will use prod on top level to show that root module variable value will override the default of module itself.
}

output "MODULEHOSTNAME" {
  value = "${module.mighty_trousers.hostname}"
}

resource "aws_security_group" "default" {
  name        = "Default SG"
  description = "Allow SSH access"
  vpc_id      = "${aws_vpc.my_vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
