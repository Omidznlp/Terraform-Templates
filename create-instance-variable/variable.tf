
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
default = "eu-north-1"
}
variable "awsprops" {
    type = map
    default = {
    vpc = "vpc-0160b9d979d050c17"
    ami = "ami-04429d960e0f4871e"
    itype = "t3.micro"
    subnet = "subnet-01264ef8b28b45749"
    publicip = true
    keyname = "awskey"
    secgroupname = "IAC-Sec-Group"
  }
}