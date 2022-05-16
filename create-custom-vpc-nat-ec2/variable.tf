
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
default = "eu-north-1"
}
variable "awsprops" {
    type = map
    default = {
    ami = "ami-04429d960e0f4871e"
    itype = "t3.micro"
    publicip = true
    keyname = "awskey"
  }
}