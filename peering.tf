resource "aws_vpc_peering_connection" "default" {
  # peer_owner_id = var.peer_owner_id  --> defaults to current account aws provider is currently connected to if we want peering connection between two diffrent accounts(cross account peering) then we use value as acceptor account owner id
  count = var.is_peering_required ? 1 : 0 # count = 0 makes peering connection optional
  peer_vpc_id = data.aws_vpc.default.id  # target vpc or acceptor vpc
  vpc_id = aws_vpc.main.id       # requestor vpc id


  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  auto_accept = true    # accepts vpc peering request acceptor vpc if same account vpc's

  tags = merge(
        var.vpc_tags,
        local.common_tags,
    {
        Name = "${local.common_name_suffix}-default"
    }
   )
}

# adding route of default vpc(cidr) in public route table of  requestor vpc
resource "aws_route" "public_peering" {
  count = var.is_peering_required ? 1 : 0
  route_table_id = aws_route_table.public.id
  destination_cidr_block = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id 
}

# adding route of our vpc(cidr) in default vpc's main route table
resource "aws_route" "default_peering" {
  count = var.is_peering_required ? 1 : 0
  route_table_id = data.aws_route_table.main.id 
  destination_cidr_block = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id 
}