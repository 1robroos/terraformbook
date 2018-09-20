# terraformbook
Getting started with terraform Second edition

De module geeft terug :
output "hostname" {
  value = "${aws_instance.mighty-trousers.private_dns}"
  # THis you can use in the template file in your root module.
}

En die output geef je terug aan je root module:
module "crazy_foods" {
  source = "./modules/application"
  vpc_id = "${aws_vpc.my_vpc.id}"
  subnet_id = "${aws_subnet.public.id}"
  name = "CrazyFoods "${module.mighty-trousers.hostname}"

}
-------------------------------------------------------------------
To taint a instance:
terraform taint -module=crazy_foods aws_instance.mighty-trousers 

SG can not be deleted before instance is deleted.
-------------------------------------------------------------------


#outputs:
rob@rob-Latitude-5590:~/Documents/github/packt-terraform$ terraform output

The state file either has no outputs defined, or all the defined
outputs are empty. Please define an output in your configuration
with the `output` keyword and run `terraform refresh` for it to
become available. If you are using interpolation, please verify
the interpolated value is not empty. You can use the 
`terraform console` command to assist.

rob@rob-Latitude-5590:~/Documents/github/packt-terraform$ terraform output -module=mighty_trousers hostname
ip-10-0-1-70.eu-central-1.compute.internal
--
# Output opnemen in root module: terraform apply verplicht:
#Get output in root module:
output "hostname" {
  value = "${module.mighty_trousers.hostname}"

  # THis you can use in the template file in your root module.
}

rob@rob-Latitude-5590:~/Documents/github/packt-terraform$ terraform output
The state file either has no outputs defined, or all the defined
outputs are empty. Please define an output in your configuration
with the `output` keyword and run `terraform refresh` for it to
become available. If you are using interpolation, please verify
the interpolated value is not empty. You can use the 
`terraform console` command to assist.

rob@rob-Latitude-5590:~/Documents/github/packt-terraform$ terraform apply
aws_vpc.my_vpc: Refreshing state... (ID: vpc-0465ca2e4e6bc7075)
aws_subnet.public: Refreshing state... (ID: subnet-008ed3ae9889de3f6)
aws_security_group.allow_http: Refreshing state... (ID: sg-0f6c180a6f4162413)
aws_security_group.allow_http: Refreshing state... (ID: sg-02f1901b9652cc9a0)
aws_instance.mighty-trousers: Refreshing state... (ID: i-0b3771192947c579a)
aws_instance.mighty-trousers: Refreshing state... (ID: i-03ab7e65d11d8d64e)
aws_security_group.allow_http: Refreshing state... (ID: sg-01a9ae6d05d44e236)
aws_instance.mighty-trousers: Refreshing state... (ID: i-09a0ec38b9799e35e)

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

hostname = ip-10-0-1-70.eu-central-1.compute.internal

rob@rob-Latitude-5590:~/Documents/github/packt-terraform$ terraform output
hostname = ip-10-0-1-70.eu-central-1.compute.internal
--------------------------------------------------------------------
Voor iedere instance die met de module is gecreerd kun je de hostname uitlezen:
rob@rob-Latitude-5590:~/Documents/github/packt-terraform$ terraform output -module=mighty_trousers hostname
ip-10-0-1-70.eu-central-1.compute.internal
rob@rob-Latitude-5590:~/Documents/github/packt-terraform$ terraform output -module=ILOVEIT hostname
ip-10-0-1-135.eu-central-1.compute.internal
rob@rob-Latitude-5590:~/Documents/github/packt-terraform$ terraform output -module=crazy_foods hostname
ip-10-0-1-4.eu-central-1.compute.internal

En die van mighty_trousers is gebruikt om terug te geven aan de root module en om die te verwerken in een tag van de crazy_foods instance.
