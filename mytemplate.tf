provider "aws" {
  region = "${var.region}"
}

data "aws_vpc" "management_layer" {
  id = "vpc-069ca85ebb3419451"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_vpc_peering_connection" "my_vpc-management" {
  peer_vpc_id = "${data.aws_vpc.management_layer.id}"
  vpc_id      = "${aws_vpc.my_vpc.id}"
  auto_accept = true
}

# Looking up in map subnet_cidrs in variables.tf :
resource "aws_subnet" "public" {
  vpc_id     = "${aws_vpc.my_vpc.id}"
  cidr_block = "${var.subnet_cidrs["public"]}"
}

# Looking up in map subnet_cidrs in variables.tf :
resource "aws_subnet" "private" {
  vpc_id     = "${aws_vpc.my_vpc.id}"
  cidr_block = "${var.subnet_cidrs["private"]}"
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

# Making use of 'list variable' in cidr_blocks for allow_ssh_access
resource "aws_security_group" "default" {
  name        = "Default SG"
  description = "Allow SSH access"
  vpc_id      = "${aws_vpc.my_vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.allow_ssh_access}"]

    #cidr_blocks = ["0.0.0.0/0"]
  }
}
