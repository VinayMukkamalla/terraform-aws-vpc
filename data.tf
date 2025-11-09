# for dynamic reading of aws availability zones in current region mentioned in aws configure or in provider.tf 

data "aws_availability_zones" "available"{  # used in locals.tf for  vpc.tf public_subnet_cidrs

    state = "available"
}

# for default vpc id
data "aws_vpc" "default" {
  default = true
}

# for default vpc's default route table main's id
data "aws_route_table" "main" {
  vpc_id = data.aws_vpc.default.id  # using above default vpc to get it's id
  filter {
    name = "association.main" # checks whether there is a main route associated with above vpc id
    values = ["true"] 
  }
}