module "ec2_instance" {
    source = "github.com/terraform-aws-modules/terraform-aws-ec2-instance.git"
    name    = "my-intsance"
    ami     = "ami-022b0631072a1aefe"
    instance_type = "t3.micro"
    subnet_id   = "subnet-004475743c998ffee"
    count = var.environment == "Production" ? 2 : 1
    tags = {
    Terraform   = "true"
    Environment = "test"
    }
}