# terraformbook

Getting started with terraform Second edition

Using list variables
o  extra_sgs   = ["${aws_security_group.default.id}"] #pass xtra SG  to the module, wrapping it with square brackets 

