# terraformbook

Getting started with terraform Second edition

##Terraform_environment_variables
Terraform will automatically read all environment variables with the TF_VAR_ prefix.
For example, to set value for the region variable, you would need to set the TF_VAR_region environment variable.


rob@rob-Latitude-5590:~/Documents/github/packt-terraform$ TF_VAR_environment=sandbox terraform plan | grep instance_type
      instance_type:                         "t3.micro"
