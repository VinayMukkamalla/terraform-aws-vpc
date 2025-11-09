variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
  description = "Please Provide VPC CIDR"
}

variable "instance_tenancy" {
  type = string
  default = "default"
}

variable "project_name" {
  type = string
  
}

variable "environment" {
  type = string
}

variable "vpc_tags" {
  type = map 
  default = {}
}

variable "igw_tags" {
  type = map 
  default = {}
}

variable "public_subnet_cidrs" {
  type = list 
}

variable "public_subnet_tags" {
  type = map 
  default = {}

}

variable "private_subnet_cidrs" {
  type = list 
}

variable "private_subnet_tags" {
  type = map 
  default = {}
  
}

variable "database_subnet_cidrs" {
  type = list 
}

variable "database_subnet_tags" {
  type = map 
  default = {}
  
}

variable "public_route_table_tags" {
  type = map 
  default = {}
}

variable "private_route_table_tags" {
  type = map 
  default = {}
}

variable "database_route_table_tags" {
  type = map 
  default = {}
}


variable "eip_tags" {
  type = map 
  default = {}
}

variable "nat_gateway_tags" {
  type = map 
  default = {}
}
