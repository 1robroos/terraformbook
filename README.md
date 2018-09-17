# terraformbook

Getting started with terraform Second edition

Supplying variables inline
The easiest (after interactive mode) way to set variable values is to specify them as an argument to Terraform command.
It's done with the multiple -var arguments to the command with the name and value of the variable following:


$ terraform plan -var 'environment=dev' | grep instance_type
      instance_type:                         "t2.micro"

$ terraform plan -var 'environment=prod' | grep instance_type
      instance_type:                         "t2.large"

In mytemplate.tf:
Looking up in map subnet_cidrs in variables.tf :
resource "aws_subnet" "public" {
 vpc_id     = "${aws_vpc.my_vpc.id}"
 cidr_block = "${var.subnet_cidrs["public"]}"
}


Also test with  making use of 'list variable' in cidr_blocks for allow_ssh_access

This is powerfull:
terraform plan -var 'subnet_cidrs={public = "172.0.16.0/24", private = "172.0.17.0/24"}'
