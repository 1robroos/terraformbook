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
  #Terraform, via interpolation syntax, allows us to reference any other resource it manages using the following syntax: ${RESOURCE_TYPE.RESOURCE_NAME.ATTRIBUTE_NAME}.
  vpc_id     = "${aws_vpc.my_vpc.id}"
  cidr_block = "10.0.1.0/24"
}

module "MYAPPSERVER" {
  source    = "./modules/application"
  vpc_id    = "${aws_vpc.my_vpc.id}"
  subnet_id = "${aws_subnet.public.id}"
  name      = "MYAPPSERVER"
}

module "crazy_foods" {
  source    = "./modules/application"
  vpc_id    = "${aws_vpc.my_vpc.id}"
  subnet_id = "${aws_subnet.public.id}"
  name      = "CrazyFoods ${module.MYAPPSERVER.hostname}"
}

module "ILOVEIT" {
  source    = "./modules/application"
  vpc_id    = "${aws_vpc.my_vpc.id}"
  subnet_id = "${aws_subnet.public.id}"
  name      = "ILOVEIT"
}

#Get output in root module from modules/appliation module:
output "hostname" {
  value = "${module.MYAPPSERVER.hostname}"
}
