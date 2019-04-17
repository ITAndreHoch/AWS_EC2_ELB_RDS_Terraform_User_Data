###################
# Internet Gateway
###################

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.VPC-OneWeb.id}"

  tags = {
    Name = "igw"
  }
}

##############################
# Subnets - Public & Private
##############################

resource "aws_subnet" "Public-Primary" {
  vpc_id     = "${aws_vpc.VPC-OneWeb.id}"
  cidr_block = "172.10.1.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[0]}" 
  tags = {
    Name = "Public-Primary"
  }
}

resource "aws_subnet" "Public-Secondary" {
  vpc_id     = "${aws_vpc.VPC-OneWeb.id}"
  cidr_block = "172.10.2.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  tags = {
    Name = "Public-Secondary"
  }
}


resource "aws_subnet" "Private-Primary" {
  vpc_id     = "${aws_vpc.VPC-OneWeb.id}"
  cidr_block = "172.10.3.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  tags = {
    Name = "Private-Primary"
  }
}

resource "aws_subnet" "Private-Secondary" {
  vpc_id     = "${aws_vpc.VPC-OneWeb.id}"
  cidr_block = "172.10.4.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  tags = {
    Name = "Private-Secondary"
  }
}

resource "aws_subnet" "db1" {
  vpc_id     = "${aws_vpc.VPC-OneWeb.id}"
  cidr_block = "172.10.5.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  tags = {
    Name = "Private-Primary"
  }
}

resource "aws_subnet" "db2" {
  vpc_id     = "${aws_vpc.VPC-OneWeb.id}"
  cidr_block = "172.10.6.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  tags = {
    Name = "DB-secondary"
  }
}

####################################
# Route table association to subnet
####################################

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.VPC-OneWeb.id}"

  tags {
    Name = "public"
  }
}

resource "aws_route" "r" {
  route_table_id            = "${aws_route_table.public.id}"
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.igw.id}"
}

#######################
# Subnets Associations
#######################
resource "aws_route_table_association" "assoc1" {
  subnet_id      = "${aws_subnet.Public-Primary.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "assoc2" {
  subnet_id      = "${aws_subnet.Public-Secondary.id}"
  route_table_id = "${aws_route_table.public.id}"
}
