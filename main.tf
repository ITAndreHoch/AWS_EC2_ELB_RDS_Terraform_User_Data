provider "aws" {
  region     = "eu-central-1"
  shared_credentials_file = "/Users/andrzejhochbaum/.aws/credentials"
}


# Declare the data source
data "aws_availability_zones" "available" {}


# Resources

resource "aws_vpc" "VPC-OneWeb" {
  cidr_block = "172.10.0.0/16"

  tags = {
    Name = "VPC-OneWeb"
  }
}
