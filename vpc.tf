resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr #"10.0.0.0/16"
  instance_tenancy = var.instance_tenancy #"default"
  enable_dns_hostnames = true   
   tags   = merge(
    var.vpc_tags,
    local.common_tags,
    {
        Name = local.common_name_suffix
    }
   )
}

# IGW
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id 
  tags   = merge(
    var.igw_tags,
    local.common_tags,
    {
        Name = local.common_name_suffix
    }
   )
}

# public subnets
resource "aws_subnet" "public"{
    count = length(var.public_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_cidrs[count.index]
    availability_zone = local.az_names[count.index]
    map_public_ip_on_launch = true

    tags = merge(
    var.public_subnet_tags,
    local.common_tags,
    {
        Name = "${local.common_name_suffix}-public-${local.az_names[count.index]}"   #roboshop-dev-public-us-east-1a
    }
   )
}

# private subnets
resource "aws_subnet" "private"{
    count = length(var.private_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_cidrs[count.index]
    availability_zone = local.az_names[count.index]
    
    tags = merge(
    var.private_subnet_tags,
    local.common_tags,
    {
        Name = "${local.common_name_suffix}-private-${local.az_names[count.index]}"   #roboshop-dev-public-us-east-1a
    }
   )
}

# database subnets
resource "aws_subnet" "database"{
    count = length(var.database_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    cidr_block = var.database_subnet_cidrs[count.index]
    availability_zone = local.az_names[count.index]
    
    tags = merge(
    var.database_subnet_tags,
    local.common_tags,
    {
        Name = "${local.common_name_suffix}-database-${local.az_names[count.index]}"   #roboshop-dev-public-us-east-1a
    }
   )
}

# public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.public_route_table_tags,
    local.common_tags,
    {
        Name = "${local.common_name_suffix}-public"
    }
   )
}

# private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.private_route_table_tags,
    local.common_tags,
    {
        Name = "${local.common_name_suffix}-private"
    }
   )
}

# database route table
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.database_route_table_tags,
    local.common_tags,
    {
        Name = "${local.common_name_suffix}-database"
    }
   )
}

# adding route to public route table using internet gateway
resource "aws_route" "public" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block  = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
}


# elastic ip creation to allocate to nat gateway
resource "aws_eip" "nat" {
    domain = "vpc"

    tags = merge(
        var.eip_tags,
        local.common_tags,
    {
        Name = "${local.common_name_suffix}-nat"
    }
   )
  
}


# creating nat gateway and it depends on internet gateway to work
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public[0].id 

  tags = merge(
        var.nat_gateway_tags,
        local.common_tags,
    {
        Name = "${local.common_name_suffix}"
    }
   )

  depends_on = [ aws_internet_gateway.main ]
}


# adding route to pivate route table using nat gateway
# private egress route through nat
resource "aws_route" "private" {
    route_table_id = aws_route_table.private.id
    destination_cidr_block  = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
}

# adding route to database route table using internet gateway
# database egress route through nat
resource "aws_route" "database" {
    route_table_id = aws_route_table.database.id
    destination_cidr_block  = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id 
}

# aws route table subnet association terraform,association is nothing but joining ids of both subnet and route table of similar kind. 

resource "aws_route_table_association" "public" {
    count = length(var.public_subnet_cidrs)  # two subnets available in us-eas-1a and us-east-1b
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id 
}

resource "aws_route_table_association" "private" {
    count = length(var.private_subnet_cidrs)  # two subnets available in us-eas-1a and us-east-1b
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id 
}


resource "aws_route_table_association" "database" {
    count = length(var.database_subnet_cidrs)  # two subnets available in us-eas-1a and us-east-1b
  subnet_id = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id 
}