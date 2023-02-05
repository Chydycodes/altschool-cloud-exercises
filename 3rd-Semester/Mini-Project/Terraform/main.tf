terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main_vpc" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"


  tags = {
    Name = "main_vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidr)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = element(var.public_subnet_cidr, count.index)
  availability_zone       = element(var.availability_zone, count.index)
  map_public_ip_on_launch = true


  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  count                   = length(var.private_subnet_cidr)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = element(var.private_subnet_cidr, count.index)
  availability_zone       = element(var.availability_zone, count.index)
  map_public_ip_on_launch = false


  tags = {
    Name = "private_subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "route_table"
  }
}

resource "aws_route_table_association" "route_association" {
  count          = 3
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
  route_table_id = aws_route_table.route_table.id

}

resource "aws_security_group" "my_instance_sg" {
  name        = "my_instance_sg"
  description = "Allow inbound https/ssh/http traffic"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "allow https traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow ssh traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "allow http traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    description = "allow all outbound https/ssh/htpp traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my_instance_sg"
  }
}


resource "aws_instance" "my_instance" {
  count                       = 3
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = "dekey"
  subnet_id                   = element(aws_subnet.public_subnet[*].id, count.index)
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.my_instance_sg.id]
  user_data                   = file("user_data.sh")

  tags = {
    Name = "MyInstance ${count.index + 1}"
  }
}

resource "aws_security_group" "my_lb_sg" {
  name        = "my_lb_sg"
  description = "Allow inbound https/ssh/http traffic"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "allow https traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow http traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    description = "allow all outbound https/ssh/htpp traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my_lb_sg"
  }
}

resource "aws_lb" "load_balancer" {
  name               = "load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my_lb_sg.id]
  subnets            = aws_subnet.public_subnet[*].id

  tags = {
    engineer = "chydy"
  }
}

resource "aws_lb_target_group" "lb_target" {
  name     = "lb-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:813037107263:certificate/1441ee2c-69fd-4ead-8a06-d3b361910263"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target.arn
  }
}

resource "aws_lb_target_group_attachment" "lb_tg_attach" {
  count            = 3
  target_group_arn = aws_lb_target_group.lb_target.arn
  target_id        = element(aws_instance.my_instance[*].id, count.index)
  port             = 80
}

data "aws_route53_zone" "zone" {
  zone_id      = var.zone_id
  private_zone = false
}

resource "aws_route53_record" "route_record" {
  zone_id         = data.aws_route53_zone.zone.zone_id
  name            = "terraform-test.cynthiaezenwa.me"
  type            = "A"
  allow_overwrite = true

  alias {
    name                   = aws_lb.load_balancer.dns_name
    zone_id                = aws_lb.load_balancer.zone_id
    evaluate_target_health = false
  }
}

# inventory file 
resource "local_file" "ip_output" {
  content = <<EOT
  [all]
  ${aws_instance.my_instance.*.public_ip[0]}
  ${aws_instance.my_instance.*.public_ip[1]}
  ${aws_instance.my_instance.*.public_ip[2]}
  [all:vars]
  ansible_user=ubuntu
  ansible_ssh_private_key_file=/home/vagrant/dekey.pem
  ansible_ssh_common_args='-o StrictHostKeyChecking=no'
  EOT

  filename             = "../ansible/host-inventory"
  directory_permission = "777"
  file_permission      = "777"

  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/host-inventory ../ansible/playbook.yml"
  }
}
