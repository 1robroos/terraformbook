# Provider configuration
provider "aws" {
  region                  = "eu-central-1"
  shared_credentials_file = "/home/rob/.aws/credentials"
  profile                 = "kfsoladmin"
}

# Resource configuration
resource "aws_instance" "server1" {
  ami           = "ami-337be65c"
  instance_type = "t2.micro"

  tags {
    Name = "hello-instance"
    Env = "test"
  }
}
