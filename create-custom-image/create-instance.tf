resource "aws_security_group" "project-iac-sg" {
  name = lookup(var.awsprops, "secgroupname")
  description = lookup(var.awsprops, "secgroupname")
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
resource "aws_key_pair" "aws_key" {
    key_name = "awskeyterraform"
    public_key = file(var.PUBLICKEY_PATH_HOST)
}

resource "aws_instance" "project-iac" {
  ami = lookup(var.awsprops, "ami")
  instance_type = lookup(var.awsprops, "itype")
  subnet_id = lookup(var.awsprops, "subnet") #FFXsubnet2
  associate_public_ip_address = lookup(var.awsprops, "publicip")
  key_name = aws_key_pair.aws_key.key_name

  vpc_security_group_ids = [
    aws_security_group.project-iac-sg.id
  ]
  root_block_device {
    delete_on_termination = true
    iops = 150
    volume_size = 10
    #volume_type = "gp2"
  }
  tags = {
    Name ="SERVER01"
    Environment = "DEV"
    OS = "Centos"
    Managed = "IAC"
  }

  depends_on = [ aws_security_group.project-iac-sg ]

  provisioner "file" {
      source = "httpdinstalltf.sh"
      destination = "/tmp/httpdinstalltf.sh"
    }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/httpdinstalltf.sh",
      "sudo /tmp/httpdinstalltf.sh",
    ]
  }

  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = var.INSTANCE_USERNAME
    private_key = file(var.PRIVATEKEY_PATH_HOST)
  }
}

output "ec2instance" {
  value = aws_instance.project-iac.public_ip
}