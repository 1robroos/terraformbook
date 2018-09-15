provider "aws" {
  region = "eu-central-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = "${aws_vpc.my_vpc.id}"
  cidr_block = "10.0.1.0/24"
}

#resource "aws_subnet" "private" {
#  vpc_id     = "${aws_vpc.my_vpc.id}"
#  cidr_block = "10.0.2.0/24"
#}
#resource "aws_instance" "master-instance" {
#  ami           = "ami-9bf712f4"
#  instance_type = "t2.micro"
#  subnet_id     = "${aws_subnet.public.id}"
#}
#
#resource "aws_instance" "slave-instance" {
#  ami           = "ami-9bf712f4"
#  instance_type = "t2.micro"
#  subnet_id     = "${aws_subnet.public.id}"
#
#  #      depends_on = ["aws_instance.master-instance"]
#}

module "mighty_trousers" {
  source    = "./modules/application"
  vpc_id    = "${aws_vpc.my_vpc.id}"
  subnet_id = "${aws_subnet.public.id}"
  name      = "MightyTrousers"
}

#module "crazy_foods" {
#  source    = "./modules/application"
#  vpc_id    = "${aws_vpc.my_vpc.id}"
#  subnet_id = "${aws_subnet.public.id}"
#  name = "CrazyFoods ${module.mighty_trousers.hostname}"
#}
output "MODULEHOSTNAME" {
  value = "${module.mighty_trousers.hostname}"
}

