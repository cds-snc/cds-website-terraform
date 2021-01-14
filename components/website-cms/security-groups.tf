###
# AWS EC2 Security Group
###

resource "aws_security_group" "website-cms-ec2" {
  name        = "website-cms-ec2"
  description = "Ingress - EC2 instance"
  vpc_id      = aws_vpc.website-cms.id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:AWS008
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:AWS008
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:AWS008
  }

  ingress {
    protocol    = "tcp"
    from_port   = 1337
    to_port     = 1337
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:AWS008
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    CostCenter = "website-cms"
  }
}

###
# AWS RDS Security Group
###

resource "aws_security_group" "website-cms-database" {
  name        = "website-cms-database"
  description = "Ingress - RDS instance"
  vpc_id      = aws_vpc.website-cms.id

  ingress {
    protocol    = "tcp"
    from_port   = 5432
    to_port     = 5432
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:AWS008
  }

  tags = {
    CostCenter = "website-cms"
  }
}
