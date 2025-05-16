provider "aws" {
  region     = "ap-southeast-1"  # Singapore
}

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http_4969"
  description = "Allow SSH and HTTP access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "login_app" {
  ami                    = "ami-0afc7fe9be84307e4"  # Amazon Linux 2023 - Singapore
  instance_type          = "t2.micro"
  key_name               = "sgp"  # Pastikan sudah ada key pair ini di AWS Console
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y git nodejs npm
              mkdir -p /home/ec2-user/app
              chown -R ec2-user:ec2-user /home/ec2-user/app
              EOF

  tags = {
    Name = "LoginAppServer"
  }
}

output "instance_ip" {
  description = "Public IP EC2 instance"
  value       = aws_instance.login_app.public_ip
}
