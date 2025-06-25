########################################
# 0.  TLS provider (for key generation)
########################################
terraform {
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

########################################
# 1.  Latest Amazon Linux 2 AMI (region-aware)
########################################
data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

########################################
# 2.  Generate key pair locally
########################################
resource "tls_private_key" "bastion_key" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "rs_key" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.bastion_key.public_key_openssh
}

########################################
# 3.  Security group – SSH from your IP
########################################
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-ssh"
  description = "Allow SSH from my IP"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH in"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip] # e.g. "12.34.56.78/32"
  }

  egress {
    description = "all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "bastion-ssh" }
}

########################################
# 4.  Bastion EC2 instance (public subnet-0)
########################################
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux2.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  key_name                    = aws_key_pair.rs_key.key_name
  associate_public_ip_address = true

  tags = { Name = "rs-school-bastion" }
}

########################################
# 5.  Output the private key so you can SSH
########################################
output "bastion_private_key_pem" {
  description = "Save as rs-school-bastion.pem (chmod 600) to SSH."
  value       = tls_private_key.bastion_key.private_key_pem
  sensitive   = true
}
