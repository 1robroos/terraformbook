# terraformbook

Getting started with terraform Second edition

It's not an unusual situation when you need to provide long-form non-Terraform-specific text configuration to your Terraform templates. On many occasions, you need to pass to Terraform a bootstrap script for your virtual machines, or upload large file to S3, or, another example, configure IAM policies.

Sometimes, these files are static, that is, you don't need to change anything inside them, you just need to read their contents inside Terraform template. For this use case, there is a file() function. You pass a relative path to your file as an argument to this function, and it will read its contents to whatever place you need.

Dit is best wel ongemakkelijk: In je eigen "mytemplate.tf" zet je bij de module "mighty_trousers" deze attribuut:
~~~
extra_packages      = "${lookup(var.extra_packages, "MightyTrousers", "base")}" ( de auteur gebruikt "my_app" maar dat klopt volgens mij niet)
~~~
Dat is een variable die in variables.tf staat :
~~~
variable "extra_packages" {
  description = "Additional packages to install for particular module"

  default = {
    MightyTrousers = "wget bind-utils"
  }
}
~~~
IN de variables.tf van de module in ./modules/variables.tf moet je ook die variabele opnemen: variable "extra_packages" {}

En in de application.tf :
~~~
resource "aws_instance" "app-server" {
  user_data              = "${data.template_file.user_data.rendered}"

  data "template_file" "user_data" {
    template = "${file("${path.module}/user_data.sh.tpl")}"

    vars {
      packages   = "${var.extra_packages}"
      nameserver = "${var.external_nameserver}"
    }
  }
~~~
Wat omslachtig allemaal.

in user_data.sh.tpl staat;${packages} wat als waarde dan heeft: wget bind-utils
~~~
#!/usr/bin/bash
yum install ${packages} -y
echo "${nameserver}" >> /etc/resolv.conf
~~~
