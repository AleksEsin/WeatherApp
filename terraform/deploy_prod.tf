provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "prod" {
  ami                    = "ami-03d5c68bab01f3496" # Ubuntu_20.04
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.prod.id]
  user_data              = <<EOF
#!/bin/bash
sudo apt update -y
sudo apt install openjdk-11-jre -y
sudo apt-get update -y
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo docker run -p 8000:8000 -d yesinaleksey/weatherapp:v2
EOF

  tags = {
    Name = "production"
  }
}


resource "aws_security_group" "prod" {
  name        = "web_security_group"
  description = "inbound traffic"

  ingress {
    from_port   = 8000
    to_port     = 8000
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

output "dev_public_ip" {
  value = aws_instance.prod.public_ip
}