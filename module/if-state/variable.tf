
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
default = "eu-north-1"
}
variable "environment" {
    type = string
    default = "Production"
}