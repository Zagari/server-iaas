
provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "main" {
  key_name = "castellabate-key"
  public_key = file("~/.ssh/id_rsa.pub")  #  ← precisa ser igual ao que já está na AWS ou apagar a chave via console ou mudar o nome da key
}

resource "aws_security_group" "castellabate_sg" {
  name        = "castellabate-sg"
  description = "Permite SSH, HTTP, HTTPS e Minecraft"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Minecraft"
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




resource "aws_instance" "castellabate" {
  ami                         = "ami-050499786ebf55a6a" # Ubuntu Server 22.04 LTS ARM64
  instance_type               = "t4g.large"
  key_name                    = aws_key_pair.main.key_name
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.castellabate_sg.id]
  associate_public_ip_address = true
  user_data                   = file("user_data.sh")
  iam_instance_profile        = aws_iam_instance_profile.ssm_profile.name
  
  root_block_device {
    volume_size = 40
    volume_type = "gp3"
  }

  tags = {
    Name = "castellabate-tech"
  }

  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price                    = "0.0259"
      spot_instance_type          = "persistent"
      instance_interruption_behavior = "stop"
    }
  }
}
