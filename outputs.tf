output "vpc_id" {
  value = aws_vpc.main.id  # here main or this is modeule name of VPC
}

#providing public subnet ids as output to display on console
output "public_subet_ids" {
  value = aws_subnet.public[*].id
}


#providing private subnet ids as output to display on console
output "private_subet_ids" {
  value = aws_subnet.private[*].id
}


#providing database subnet ids as output to display on console
output "database_subet_ids" {
  value = aws_subnet.database[*].id
}