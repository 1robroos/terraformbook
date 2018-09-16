variable "region" {
  description = "AWS region. Changing it will lead to loss of complete stack."
  default     = "eu-central-1"
}

variable "environment" {
  default = "prod"
}
