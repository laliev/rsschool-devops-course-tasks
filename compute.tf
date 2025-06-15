############################################
# 0.  Optional:  pin the TLS provider
############################################
terraform {
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

############################################
# 1. Generate an ED25519 key pair locally
############################################
resource "tls_private_key" "bastion_key" {
  algorithm = "ED25519"
}

############################################
# 2. Register the public key in AWS
############################################
resource "aws_key_pair" "rs_key" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.bastion_key.public_key_openssh
}

############################################
# 3. Security group — SSH from your IP only
############################################
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-ssh"
  description = "Allow SSH from my IP"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from my_ip"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
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

############################################
# 4. Bastion EC2 instance in first public subnet
############################################
resource "aws_instance" "bastion" {
  ami                         = "ami-0fc5d935ebf8bc3bc" # Amazon Linux 2 in eu-central-1
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  key_name                    = aws_key_pair.rs_key.key_name
  associate_public_ip_address = true

  tags = { Name = "rs-school-bastion" }
}

############################################
# 5.  Optional output — download the private key
#     (mark as sensitive so it’s hidden in most UIs)
############################################
output "bastion_private_key_pem" {
  description = "Copy this PEM and save it to ~/.ssh/rs-school-bastion.pem (chmod 600) to SSH into the instance."
  value       = tls_private_key.bastion_key.private_key_pem
  sensitive   = true
}
