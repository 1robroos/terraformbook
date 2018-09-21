resource "aws_security_group" "SG_allow_http" {
  name        = "${var.name} allow_http"
  description = "Allow HTTP traffic"
  vpc_id      = "${var.vpc_id}"

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

/*
we will use the concat() interpolation function. This function joins multiple lists into one. 
We also better ensure that the resulting list doesn't have duplicates. 
The distinct() function will help with this; it removes all the duplicates, keeping only the first occurrence of each non-unique element. 
We will join the extra_sgs list with a list made from an app-specific SG named SG_allow_http defined in application.tf:
*/
resource "aws_instance" "app-server" {
  ami                    = "ami-337be65c"
  instance_type          = "${lookup(var.instance_type, var.environment)}"
  subnet_id              = "${var.subnet_id}"
  vpc_security_group_ids = ["${distinct(concat(var.extra_sgs, aws_security_group.SG_allow_http.*.id))}"]

  tags {
    Name = "${var.name}" # THis comes from the module definition in mytemplate.tf : name = "..." 
  }
}

# Internally, we defined that aws_security_group is not a single resource, but a list consists of a single resource
output "hostname" {
  value = "${aws_instance.app-server.private_dns}"
}

#/*Now we only need to use this extra security group ID together with an app-specific security group. 
#To achieve this, we will use the concat() interpolation function. 
#This function joins multiple lists into one. We also better ensure that the resulting list doesn't have duplicates. 
#The distinct() function will help with this; it removes all the duplicates, 
#keeping only the first occurrence of each non-unique element. 
#We will join the extra_sgs list with a list made from an app-specific SG */

