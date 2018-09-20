# Provider configuration
provider "aws" {
  region = "eu-central-1"
  shared_credentials_file = "/home/rob/.aws/credentials"
  profile                 = "kfsoladmin"
}
# Resource configuration
resource "aws_instance" "server1" {
  ami = "ami-9bf712f4"
  instance_type = "t2.micro"
  tags {
    Name = "hello-instance"
  }
}
