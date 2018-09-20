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

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP traffic"
  vpc_id      = "${aws_vpc.my_vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Resource configuration
resource "aws_instance" "master-instance" {
  ami                    = "ami-337be65c"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.public.id}"
  vpc_security_group_ids = ["${aws_security_group.allow_http.id}"]

  tags {
    Name = "server-instance"
    Env  = "test"
  }
}

resource "aws_instance" "server1" {
  ami                         = "ami-337be65c"
  instance_type               = "t2.micro"
  subnet_id                   = "${aws_subnet.public.id}"
  associate_public_ip_address = "True"

  tags {
    Name            = "client-instance"
    Env             = "test"
    master_hostname = "${aws_instance.master-instance.private_dns}"
  }

#  lifecycle {
#    ignore_changes = ["tags"]
#  }
}
