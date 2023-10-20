terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.20.1"
    }
  }

  backend "s3" {
    bucket             = "aws-demobucket-01"
    key                  = "state/terraform.tfstate1"
    region             = "us-east-1"
    encrypt            = true
    dynamodb_table = "dynamodb"
  }
}


provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "vpc1" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "open5gs-VPC1"
  }
}




# VPC 2.
resource "aws_vpc" "vpc2" {
  cidr_block       = "10.1.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "open5gs-VPC2"
  }
}

# VPC 3
resource "aws_vpc" "vpc3" {
  cidr_block       = "10.2.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "open5gs-VPC3"
  }
}

# Define Subnets
resource "aws_subnet" "subnet_vpc1_1" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a" # Change to your desired availability zone
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet_vpc1_1"
  }
}


resource "aws_subnet" "subnet_vpc2_1" {
  vpc_id                  = aws_vpc.vpc2.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "us-east-1b" # Change to your desired availability zone
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet_vpc2_1"
  }
}


resource "aws_subnet" "subnet_vpc3_1" {
  vpc_id                  = aws_vpc.vpc3.id
  cidr_block              = "10.2.1.0/24"
  availability_zone       = "us-east-1c" # Change to your desired availability zone
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet_vpc3_1"
  }
}

#InternetGateway creation
resource "aws_internet_gateway" "gw1" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "open5g-IGW-01"
  }
}

resource "aws_internet_gateway" "gw2" {
  vpc_id = aws_vpc.vpc2.id

  tags = {
    Name = "open5g-IGW-02"
  }
}

resource "aws_internet_gateway" "gw3" {
  vpc_id = aws_vpc.vpc3.id

  tags = {
    Name = "open5g-IGW-03"
  }
}

#RouteTable for public instant

resource "aws_route_table" "Public-RTC1" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw1.id
  }

  tags = {
    Name = "Public-RTC-01"
  }
}

resource "aws_route_table" "Public-RTC2" {
  vpc_id = aws_vpc.vpc2.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw2.id
  }

  tags = {
    Name = "Public-RTC-02"
  }
}

resource "aws_route_table" "Public-RTC3" {
  vpc_id = aws_vpc.vpc3.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw3.id
  }

  tags = {
    Name = "Public-RTC-03"
  }
}

#Route table association with public subnet
resource "aws_route_table_association" "public-association1" {
  subnet_id      = aws_subnet.subnet_vpc1_1.id
  route_table_id = aws_route_table.Public-RTC1.id
}

resource "aws_route_table_association" "public-association2" {
  subnet_id      = aws_subnet.subnet_vpc2_1.id
  route_table_id = aws_route_table.Public-RTC2.id
}

resource "aws_route_table_association" "public-association3" {
  subnet_id      = aws_subnet.subnet_vpc3_1.id
  route_table_id = aws_route_table.Public-RTC3.id
}

#SecurityGroup Creation

resource "aws_security_group" "SG1" {
  name        = "allow_all_traffic"
  description = "Allow all traffic"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "open5gs-SG1-public"
  }
}

#SecurityGroup Creation

resource "aws_security_group" "SG2" {
  name        = "allow_all_traffic"
  description = "Allow all traffic"
  vpc_id      = aws_vpc.vpc2.id

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "open5gs-SG2-public"
  }
}

#SecurityGroup Creation

resource "aws_security_group" "SG3" {
  name        = "allow_all_traffic"
  description = "Allow all traffic"
  vpc_id      = aws_vpc.vpc3.id

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "open5gs-SG3-public"
  }
}

# key pair creation

resource "aws_key_pair" "tf-key-pair" {
  key_name   = "tf-key-pair"
  public_key = tls_private_key.rsa.public_key_openssh
}
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "tf-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tf-key-pair"
}


#Creating EC2 instant in public subnet2

resource "aws_instance" "ec2-web1" {
  ami                         = "ami-007855ac798b5175e"
  instance_type               = "t2.medium"
  availability_zone           = "us-east-1a"
  key_name                    = "tf-key-pair"
  vpc_security_group_ids      = [aws_security_group.SG1.id]
  subnet_id                   = aws_subnet.subnet_vpc1_1.id
  associate_public_ip_address = true
  #user_data                  = file("master_node.sh")

  connection {
    type        = "ssh"
    host        = aws_instance.ec2-web1.public_ip
    user        = "ubuntu"
    private_key = tls_private_key.rsa.private_key_pem
  }
  provisioner "file" {
   source      = "./tf-key-pair"
   destination = "/home/ubuntu/tf-key-pair"
  }

  root_block_device {
    volume_size = "50"
    volume_type = "io1"
    iops        = "300"

  }


  tags = {
    Name = "instance_1"
  }
}

resource "aws_instance" "ec2-web2" {
  ami                         = "ami-007855ac798b5175e"
  instance_type               = "t2.medium"
  availability_zone           = "us-east-1b"
  key_name                    = "tf-key-pair"
  vpc_security_group_ids      = ["${aws_security_group.SG2.id}"]
  subnet_id                   = aws_subnet.subnet_vpc2_1.id
  associate_public_ip_address = true
  #user_data                  = file("master_node.sh")

 connection {
    type        = "ssh"
    host        = aws_instance.ec2-web2.public_ip
    user        = "ubuntu"
    private_key = tls_private_key.rsa.private_key_pem
  }
  provisioner "file" {
   source      = "./tf-key-pair"
   destination = "/home/ubuntu/tf-key-pair"
  }

  root_block_device {
    volume_size = "50"
    volume_type = "io1"
    iops        = "300"

  }

  tags = {
    Name = "instance_2"
  }
}

resource "aws_instance" "ec2-web3" {
  ami                         = "ami-007855ac798b5175e"
  instance_type               = "t2.medium"
  availability_zone           = "us-east-1c"
  key_name                    = "tf-key-pair"
  vpc_security_group_ids      = ["${aws_security_group.SG3.id}"]
  subnet_id                   = aws_subnet.subnet_vpc3_1.id
  associate_public_ip_address = true
  #user_data                  = file("master_node.sh")

 connection {
    type        = "ssh"
    host        = aws_instance.ec2-web3.public_ip
    user        = "ubuntu"
    private_key = tls_private_key.rsa.private_key_pem
  }
  provisioner "file" {
   source      = "./tf-key-pair"
   destination = "/home/ubuntu/tf-key-pair"
  }

  root_block_device {
    volume_size = "50"
    volume_type = "io1"
    iops        = "300"

  }

  tags = {
    Name = "instance_3"
  }
}

resource "null_resource" "null-res-01" {
  # Provisioner block defines when this null_resource should be created or recreated.
  # triggers = {
  #   instance_id = aws_instance.ec2-web1.id
  # }
  connection {
    type        = "ssh"
    host        = aws_instance.ec2-web1.public_ip
    user        = "ubuntu"
    private_key = tls_private_key.rsa.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      file("${path.module}/cloud_init.sh")
    ]
  }
  depends_on = [aws_instance.ec2-web1]
}

resource "null_resource" "null-res-02" {
  # Provisioner block defines when this null_resource should be created or recreated.
  # triggers = {
  #   instance_id = aws_instance.ec2-web1.id
  # }
  connection {
    type        = "ssh"
    host        = aws_instance.ec2-web2.public_ip
    user        = "ubuntu"
    private_key = tls_private_key.rsa.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      file("${path.module}/cloud_init2.sh")
    ]
  }
  depends_on = [aws_instance.ec2-web2]
}

resource "null_resource" "null-res-03" {
  # Provisioner block defines when this null_resource should be created or recreated.
  # triggers = {
  #   instance_id = aws_instance.ec2-web1.id
  # }
  connection {
    type        = "ssh"
    host        = aws_instance.ec2-web3.public_ip
    user        = "ubuntu"
    private_key = tls_private_key.rsa.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      file("${path.module}/cloud_init3.sh")
    ]
  }
  depends_on = [aws_instance.ec2-web3]
}
