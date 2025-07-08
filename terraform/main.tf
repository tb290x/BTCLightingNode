provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "deployer" {
  key_name   = "lightning-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "lightning_node_sg" {
  name        = "lightning-node-sg"
  description = "Allow Bitcoin and Lightning traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 8333
    to_port     = 8333
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9735
    to_port     = 9735
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "lightning_node" {
  ami                         = "ami-0d1b5a8c13042c939"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.main.id
  vpc_security_group_ids      = [aws_security_group.lightning_node_sg.id]
  key_name                    = aws_key_pair.deployer.key_name
  user_data                   = file("user_data.sh")

  tags = {
    Name = "Bitcoin-Lightning-Node"
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}