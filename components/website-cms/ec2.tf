data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_eip" "website-cms" {
  instance   = aws_instance.website-cms.id
  depends_on = [aws_internet_gateway.website-cms]

  vpc = true

  tags = {
    Name       = var.product_name
    CostCenter = var.product_name
  }
}

resource "aws_instance" "website-cms" {
  availability_zone = element(data.aws_availability_zones.available.names, 0)
  ami               = data.aws_ami.ubuntu.id
  instance_type     = "t3.small"

  subnet_id = aws_subnet.website-cms-public.*.id[0]
  vpc_security_group_ids = [
    aws_security_group.website-cms-ec2.id
  ]

  tags = {
    Name       = var.product_name
    CostCenter = var.product_name
  }
}