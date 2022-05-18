resource "aws_security_group" "sg-aws" {
  name = lookup(var.awsprops, "sgname")
  description = lookup(var.awsprops, "sgname")
  vpc_id = lookup(var.awsprops, "vpc")
  // To Allow SSH Transport
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  // To Allow Port 80 Transport
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
data "aws_availability_zones" "available" {
  state = "available"
}
resource "aws_instance" "instance_ebs" {
  ami = lookup(var.awsprops, "ami")
  instance_type = lookup(var.awsprops, "itype")
  subnet_id = lookup(var.awsprops, "subnet") #FFXsubnet2
  associate_public_ip_address = lookup(var.awsprops, "publicip")
  key_name = lookup(var.awsprops,"key_name")
  availability_zone = data.aws_availability_zones.available.names[0]
  vpc_security_group_ids = [
    aws_security_group.sg-aws.id
  ]
  root_block_device {
    delete_on_termination = true
    iops = 150
    volume_size = 10
  }

  tags = {
    Name ="SERVER01"
    Environment = "DEV"
    OS = "Centos"
  }
  depends_on = [ aws_security_group.sg-aws ]
  user_data = file("httpdinstalltf.sh")
}
resource "aws_ebs_volume" "example" {
  availability_zone = data.aws_availability_zones.available.names[0]
  size              = 1
}
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.example.id
  instance_id = aws_instance.instance_ebs.id
}
output "ec2instance" {
  value = aws_instance.instance_ebs.public_ip
}