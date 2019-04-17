##################
# Security Gropus
##################

# OneWeb
resource "aws_security_group" "SG-OneWeb" {
  description = "allow_http_https"
  vpc_id      = "${aws_vpc.VPC-OneWeb.id}"
  name        = "SG-OneWeb"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
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
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# DB
resource "aws_security_group" "SG-DB" {
  description = "allow_access_to_DB"
  vpc_id      = "${aws_vpc.VPC-OneWeb.id}"
  name        = "SG-DB"
  
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Bastion
resource "aws_security_group" "Bastion" {
  description = "allow_ssh"
  vpc_id      = "${aws_vpc.VPC-OneWeb.id}"
  name        = "SG-Bastion"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
