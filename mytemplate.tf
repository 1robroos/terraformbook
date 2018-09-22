# Provider configuration
provider "aws" {
  region                  = "eu-central-1"
  shared_credentials_file = "/home/rob/.aws/credentials"
  profile                 = "kfsoladmin"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = "${aws_vpc.my_vpc.id}"
  cidr_block = "10.0.1.0/24"
}

# Using an already existing VPC :Data sources are referenced with the data keyword in front of resource name.
# they are readonly
data "aws_vpc" "management_layer" {
  id = "vpc-069ca85ebb3419451"
}

resource "aws_vpc_peering_connection" "my_vpc-management" {
  peer_vpc_id = "${data.aws_vpc.management_layer.id}"
  vpc_id      = "${aws_vpc.my_vpc.id}"
  auto_accept = true
}

# another static data source: a template file 
resource "aws_key_pair" "terraform" {
  key_name   = "terraformkey"
  public_key = "${file("/home/rob/.ssh/terraformkey.pub")}"
}

module "mod_appserver" {
  source    = "./modules/application"
  vpc_id    = "${aws_vpc.my_vpc.id}"
  subnet_id = "${aws_subnet.public.id}"
  name      = "MightyTrousers"
  key_name  = "${aws_key_pair.terraform.key_name}"
  environment = "${var.environment}"
}
module "mod_dbserver" {
  source    = "./modules/application"
  vpc_id    = "${aws_vpc.my_vpc.id}"
  subnet_id = "${aws_subnet.public.id}"
  name      = "Mydataabsae"
  key_name  = "${aws_key_pair.terraform.key_name}"
  environment = "${var.environment}"
}
