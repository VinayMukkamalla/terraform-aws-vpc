# Terraform AWS VPC

This module creates the following resources
* VPC
* IGW - Internet gateway
* 2 public subnets in us-east-1a and us-east-1b AZ
* 2 private subnets in us-east-1a and us-east-1b AZ
* 2 database  subnets in us-east-1a and us-east-1b AZ
* public route table
* private route table
* database route table
* EIP - elastic ip for NAT
* creates NAT gateway in public subnet us-east-1a AZ
* Adds internet route through IGW to the public route table
* Adds internet route through NAT to the private and database route tables
* Route table associations with subnets
* VPC to default VPC peering connection
* creates route to default vpc in public route table of custom VPC
* creates route to custom VPC in main route table of default VPC


### Inputs

* vpc_cidr - (Required) user must pass cidr range of vpc
* instance_tenancy - (optional) defaults to default specify dedicated if required
* project_name - (Required) user must pass project name
* environment - (Required) user must pass environment name 
* vpc_tags - (optional)
* igw_tags - (optional)
* public_subnet_cidrs -(Required) user must provide subnet cidr range 
* public_subnet_tags - (optional)
* private_subnet_cidrs -(Required) user must provide subnet cidr range 
* private_subnet_tags - (optional)
* databse_subnet_cidrs -(Required) user must provide subnet cidr range 
* database_subnet_tags - (optional)
* public_route_table_tags - (optional)
* private_route_table_tags - (optional)
* database_route_table_tags - (optional)
*  eip_tags - (optional)
*  nat_gateway_tags - (optional)
*  is_peering_required - (optional) by default set to true override if vpc peering not required


### outputs

* vpc_id - VPC id of created VPC
* public_subet_ids - list of public subnet ids
* private_subet_ids - list of private subnet ids
* database_subet_ids - list of database subnet ids
