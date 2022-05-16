resource "aws_security_group" "custom-sg-public" {
  name = "custom-sg-public"
  description = "custom-sg-public"
  vpc_id = aws_vpc.customvpc.id
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
resource "aws_security_group" "custom-sg-private" {
  name = "custom-sg-private"
  description = "custom-sg-private"
  vpc_id = aws_vpc.customvpc.id
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
    cidr_blocks = ["10.0.2.0/24"]
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

resource "aws_instance" "instance-public-subnet" {
  ami = lookup(var.awsprops, "ami")
  instance_type = lookup(var.awsprops, "itype")
  subnet_id = aws_subnet.subnet-public-1.id
  associate_public_ip_address = lookup(var.awsprops, "publicip")
  key_name = lookup(var.awsprops, "keyname")

  vpc_security_group_ids = [
    aws_security_group.custom-sg-public.id
  ]
  root_block_device {
    delete_on_termination = true
    iops = 150
    volume_size = 10
    #volume_type = "gp2"
  }
  tags = {
    Name ="SERVER01-public"
    Environment = "DEV"
    OS = "Centos"
  }

  depends_on = [ aws_security_group.custom-sg-public]
}

resource "aws_instance" "instance-private-subnet" {
  ami = lookup(var.awsprops, "ami")
  instance_type = lookup(var.awsprops, "itype")
  subnet_id = aws_subnet.subnet-private-1.id
  key_name = lookup(var.awsprops, "keyname")
  vpc_security_group_ids = [
    aws_security_group.custom-sg-private.id
  ]
  root_block_device {
    delete_on_termination = true
    iops = 150
    volume_size = 10
    #volume_type = "gp2"
  }
  tags = {
    Name ="SERVER02-private"
    Environment = "DEV"
    OS = "Centos"
  }

  depends_on = [ aws_security_group.custom-sg-private]
}

output "ec2instance" {
  value = aws_instance.instance-public-subnet.public_ip
}