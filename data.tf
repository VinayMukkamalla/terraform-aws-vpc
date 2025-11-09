# for dynamic reading of aws availability zones in current region mentioned in aws configure or in provider.tf 

data "aws_availability_zones" "available"{  # used in locals.tf for  vpc.tf public_subnet_cidrs

    state = "available"
}