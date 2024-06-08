
######## creating a vpc ##########
resource "aws_vpc" "first_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = var.enable_dns_hostnames # 
  tags = merge(
    var.common_tags,
    var.vpc_tags,{
        Name = local.resource_name
    }
  )
}

############ internet gateway creation #######

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.first_vpc.id
  tags = merge(
    var.common_tags,
    var.IGW_tags,
    {
      Name = local.resource_name
    }
  )
}

######### public subnet creation ############
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.first_vpc.id
  map_public_ip_on_launch = true
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
  tags = merge(
    var.common_tags,
    {
    Name = "${local.resource_name}-public-${local.az_names[count.index]}"
    }
  )
}

############# Private subnet creation ########
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.first_vpc.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
  tags = merge(
    var.common_tags,
    {
    Name = "${local.resource_name}-private-${local.az_names[count.index]}"
    }
  )
}

######### Database subnet creation #########
resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidrs)
  vpc_id     = aws_vpc.first_vpc.id
  cidr_block = var.database_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
  tags = merge(
    var.common_tags,
    {
    Name = "${local.resource_name}-database-${local.az_names[count.index]}"
    }
  )
}

######### creating elastic ip #########
resource "aws_eip" "elastic_ip" {
  domain   = "vpc"
}

###### Creating NAT gateway ########
resource "aws_nat_gateway" "nat_gate" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.common_tags,
    var.nat_gatewasy_tags,{
    Name = local.resource_name
  }
  )
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

## Till above we have created vpc , internet gateway attaching to vpc also included , nat gateway attaching , subnets 2 public with 2 zones , 2 privte with 2 zones , 2 databse with 2 zones , 
## Now we will be creating route tables , routes 

#### Creating public route table ######
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.first_vpc.id # we are just creating a route table , routes will be added separately
  tags =  merge(
    var.common_tags,
    var.public_route_table_tags,{
    Name = "${local.resource_name}-public"
  }
  )
}

#### Creating private route table ######
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.first_vpc.id # we are just creating a route table , routes will be added separately
  tags =  merge(
    var.common_tags,
    var.private_route_table_tags,{
    Name = "${local.resource_name}-private"
  }
  )
}

#### Creating database route table ######
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.first_vpc.id # we are just creating a route table , routes will be added separately
  tags =  merge(
    var.common_tags,
    var.database_route_table_tags,{
    Name = "${local.resource_name}-database"
  }
  )
}

#### Now adding routes to the route tables below is public  #######
resource "aws_route" "public_route" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}
# adding route to private route table #####
resource "aws_route" "private_route" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.nat_gate.id
}

# adding route to database route table #####
resource "aws_route" "database_route" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.nat_gate.id
}

#### associating route tables to subnets ######

resource "aws_route_table_association" "public" {
  count = lengt(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table_association" "private" {
  count = lengt(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
  count = lengt(var.database_subnet_cidrs)
  subnet_id      = element(aws_subnet.database[*].id, count.index)
  route_table_id = aws_route_table.database.id
}
