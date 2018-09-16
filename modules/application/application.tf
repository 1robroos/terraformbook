resource "aws_security_group" "allow_http" {
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

resource "aws_instance" "app-server" {
  ami                    = "ami-337be65c"
  instance_type          = "${lookup(var.instance_type, var.environment)}"
  subnet_id              = "${var.subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.allow_http.id}"]

  tags {
    Name = "${var.name}"
  }
}

output "hostname" {
  value = "${aws_instance.app-server.private_dns}"
}
#Terraform provides the lookup() interpolation function. This function accepts map as the first argument, the key to look for in this map as the second argument, and an optional default value as the third argument. 
#We did not specify the default value inside the lookup() function; there is already a default on both module and root levels.
#Maps give you more flexibility compared with regular string variables.
