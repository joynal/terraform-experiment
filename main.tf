provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "application_server" {
  ami = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.nano"

  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello world!" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  user_data_replace_on_change = true

  tags = {
    Name = "application_server_tag"
    Test = "additional_tag"
  }
}

resource "aws_security_group" "instance" {
  name = "application_server_SG"

  ingress {
    from_port = 8080
    to_port  = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}