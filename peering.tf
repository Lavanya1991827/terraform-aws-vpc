#creating VPC peering
resource "aws_vpc_peering_connection" "peering" {
  count =var.is_peering_required ? 1: 0
  vpc_id        = aws_vpc.main.id
  peer_vpc_id   = var.acceptor_vpc_id == "" ? data.aws_vpc.default.id : var.acceptor_vpc_id  #if user gives we are using that otherwise taking default vpc
  auto_accept = var.acceptor_vpc_id == "" ? true : false
   tags = merge(
        var.common_tags,
        var.vpc_peering_tags,
        {
            Name = "${local.name}"
        }
    )
}

# route peering in acceptor VPC table
resource "aws_route" "acceptor_route" {
  count = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
  route_table_id            = data.aws_route_table.default.id    # getting default route table of defualt VPC.
  destination_cidr_block    = var.vpc_cidr                     # cidr of requestor vpc (we created VPC CIDR)
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

# route peering in requestor VPC -public route table
resource "aws_route" "public_peering" {
  count = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
  route_table_id            = aws_route_table.public.id   # getting public route table of requstor VPC.
  destination_cidr_block    = data.aws_vpc.default.cidr_block          # cidr of acceptor vpc (default VPC CIDR)
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

# route peering in requestor VPC -private route table
resource "aws_route" "private_peering" {
  count = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
  route_table_id            = aws_route_table.private.id   # getting priavte route table of requstor VPC.
  destination_cidr_block    = data.aws_vpc.default.cidr_block          # cidr of acceptor vpc (default VPC CIDR)
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

# route peering in requestor VPC -databse route table
resource "aws_route" "databse_peering" {
  count = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
  route_table_id            = aws_route_table.database.id   # getting databse route table of requstor VPC.
  destination_cidr_block    = data.aws_vpc.default.cidr_block          # cidr of acceptor vpc (default VPC CIDR)
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}