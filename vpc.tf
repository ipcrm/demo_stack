resource "aws_vpc" "demo_stack-region-vpc" {
  cidr_block           = "10.${lookup(var.vpc_slash_16, var.region)}.0.0/16"
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags {
    Name      = "demo_stack-${var.region}-vpc"
    Terraform = "True"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.demo_stack-region-vpc.id}"

  tags {
    Name      = "demo_stack-${var.region}-igw"
    Terraform = "True"
  }
}

resource "aws_route_table" "to-igw" {
  vpc_id = "${aws_vpc.demo_stack-region-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
}

# This data block grabs 2 availabile AZs in the region
data "aws_availability_zones" "available" {}

# e.g. Create subnets in the first two available availability zones
resource "aws_subnet" "demo_stack" {
  count                   = "2"
  vpc_id                  = "${aws_vpc.demo_stack-region-vpc.id}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block              = "10.${lookup(var.vpc_slash_16, var.region)}.${count.index}.0/24"
  depends_on              = ["aws_internet_gateway.gw"]
  map_public_ip_on_launch = "True"

  tags {
    Name      = "demo_stack-subnet-az${data.aws_availability_zones.available.names[count.index]}"
    Terraform = "True"
  }
}

resource "aws_route_table_association" "demo_stack" {
  count          = "2"
  subnet_id      = "${aws_subnet.demo_stack.*.id[count.index]}"
  route_table_id = "${aws_route_table.to-igw.id}"
}
