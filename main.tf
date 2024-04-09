#
# VPC resources
#
resource "aws_vpc" "test" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
}


resource "aws_subnet" "public-sub-1a" {

  vpc_id                  = aws_vpc.test.id
  cidr_block              = var.public_subnet_a_cidr_blocks
  availability_zone       = var.availability_zone_one
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public-sub-1b" {

  vpc_id                  = aws_vpc.test.id
  cidr_block              = var.public_subnet_b_cidr_blocks
  availability_zone       = var.availability_zone_two
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private-sub-1a" {
  
  vpc_id            = aws_vpc.test.id
  cidr_block        = var.private_subnet_a_cidr_blocks
  availability_zone = var.availability_zone_one
}

resource "aws_subnet" "private-sub-1b" {
  
  vpc_id            = aws_vpc.test.id
  cidr_block        = var.private_subnet_b_cidr_blocks
  availability_zone = var.availability_zone_two
}

resource "aws_internet_gateway" "test" {
  vpc_id = aws_vpc.test.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.test.id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.test.id
}

resource "aws_eip" "nat" {

  vpc = true
}

resource "aws_nat_gateway" "test" {
  depends_on = [aws_internet_gateway.test]


  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-sub-1a.id
}

resource "aws_route_table" "private" {

  vpc_id = aws_vpc.test.id

}

resource "aws_route" "private" {

  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.test.id
}

resource "aws_route_table_association" "public1" {

  subnet_id      = aws_subnet.public-sub-1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {

  subnet_id      = aws_subnet.public-sub-1b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private1" {

  subnet_id      = aws_subnet.private-sub-1a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private2" {

  subnet_id      = aws_subnet.private-sub-1b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "jumpbox_sg" {
  name        =  var.instance_sg_name
  description = "Security group for the EC2 instance"
  vpc_id      = var.vpc_id

  // Define ingress rules as needed
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Define egress rules as needed
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jumpbox" {
  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id       = var.subnet_id
  key_name        = var.key_pair
  security_groups = [aws_security_group.jumpbox_sg.id]
  associate_public_ip_address = true

  // Define additional configuration as needed
  // For example, user_data, tags, etc.
  
  // Define root volume
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 30  # Size in GB
    delete_on_termination = true
  }
}
