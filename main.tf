resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support = var.enable_dns_support
  
  tags = merge(var.common_tags,
                var.vpc_tags,
                 {
                    "Name"= "${var.projectname}-${var.env}"
                })
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags,
                var.gw_tags,
                {
                    "Name"= "${var.projectname}-${var.env}"
                })
}

resource "aws_subnet" "public" {
    count = length(var.public_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_cidr_block[count.index]
  availability_zone = var.az[count.index]
  map_public_ip_on_launch = "true"
  tags = merge(var.common_tags,
                 {
                    "Name"= "${var.projectname}-${var.env}-public-${var.az[count.index]}"
                })
}

resource "aws_subnet" "private" {
    count = length(var.private_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_cidr_block[count.index]
  availability_zone = var.az[count.index]

  tags = merge(var.common_tags,
                {
                    "Name"= "${var.projectname}-${var.env}-private-${var.az[count.index]}"
                })
}

resource "aws_subnet" "database" {
    count = length(var.database_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_cidr_block[count.index]
  availability_zone = var.az[count.index]

  tags = merge(var.common_tags,
                 {
                    "Name"= "${var.projectname}-${var.env}-database-${var.az[count.index]}"
                })
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id


   tags = merge(var.common_tags,
                 {
                    "Name"= "${var.projectname}-${var.env}-public"
                },var.public_routetable_tags)
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
 
   tags = merge(var.common_tags,
                 {
                    "Name"= "${var.projectname}-${var.env}-private"
                },var.private_routetable_tags)
}
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id
 
   tags = merge(var.common_tags,
                 {
                    "Name"= "${var.projectname}-${var.env}-database"
                },var.database_routetable_tags)
}

resource "aws_route_table_association" "public_subnet_association" {
     count = length(var.public_cidr_block)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private_subnet_association" {
     count = length(var.private_cidr_block)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "db_subnet_association" {
     count = length(var.database_cidr_block)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}

resource "aws_eip" "roboshop_eip" {
  tags = {
      "Name"=  "${var.projectname}-${var.env}"
  }
}

resource "aws_nat_gateway" "roboshop" {
  allocation_id = aws_eip.roboshop_eip.id
  subnet_id     = aws_subnet.public[0].id
  tags = merge(var.common_tags,
                 {
                    "Name"= "${var.projectname}-${var.env}-NAT"
                })

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_db_subnet_group" "roboshop" {
  name       = var.projectname
  subnet_ids = aws_subnet.database[*].id

  tags = merge(
    var.common_tags,
    {
        "Name"= "${var.projectname}-${var.env}"
    },
    var.db_subnet_group_tags
  )
}

# this resource for vpc _peering works for only the vpc's which are in the same region and same account
resource "aws_vpc_peering_connection" "roboshop-peering" {
  count = var.is_peering_connection ? 1 :0
  vpc_id        = aws_vpc.main.id
  peer_vpc_id   = var.peer_vpc_id
  #peer_region   = "us-east-1"
  auto_accept   = true  

  tags = merge(
    var.common_tags,
    {
        Name = "${var.projectname}-${var.env}"
    }
  )
}
resource "aws_route" "public_route" {
  
  route_table_id            = aws_route_table.public.id  # Replace with your actual route table ID
  destination_cidr_block   =   var.public_route# Replace with the CIDR block of the peer VPC
  gateway_id = aws_internet_gateway.gw.id  # Replace with your VPC peering connection ID
}
resource "aws_route" "private_route" {
  
  route_table_id            = aws_route_table.private.id  # Replace with your actual route table ID
  destination_cidr_block   =    "0.0.0.0/0"# Replace with the CIDR block of the peer VPC
  nat_gateway_id = aws_nat_gateway.roboshop.id  # Replace with your VPC peering connection ID
}
resource "aws_route" "database_route" {
  count = var.is_peering_connection ? 1 :0
  route_table_id            = aws_route_table.database.id  # Replace with your actual route table ID
  destination_cidr_block   =   "0.0.0.0/0"# Replace with the CIDR block of the peer VPC
   nat_gateway_id = aws_nat_gateway.roboshop.id  # Replace with your VPC peering connection ID
}

resource "aws_route" "public_rt_peering_route" {
  count = var.is_peering_connection ? 1 :0
  route_table_id            = aws_route_table.public.id  # Replace with your actual route table ID
  destination_cidr_block   =    var.peer_cidr_block# Replace with the CIDR block of the peer VPC
  vpc_peering_connection_id = aws_vpc_peering_connection.roboshop-peering[count.index].id  # Replace with your VPC peering connection ID
}

resource "aws_route" "private_rt_peering_route" {
  count = var.is_peering_connection ? 1 :0
  route_table_id            = aws_route_table.private.id  # Replace with your actual route table ID
  destination_cidr_block   =    var.peer_cidr_block# Replace with the CIDR block of the peer VPC
  vpc_peering_connection_id = aws_vpc_peering_connection.roboshop-peering[count.index].id  # Replace with your VPC peering connection ID
}

resource "aws_route" "database_rt_peering_route" {
  count = var.is_peering_connection ? 1 :0
  route_table_id            = aws_route_table.database.id  # Replace with your actual route table ID
  destination_cidr_block   =    var.peer_cidr_block# Replace with the CIDR block of the peer VPC
  vpc_peering_connection_id = aws_vpc_peering_connection.roboshop-peering[count.index].id  # Replace with your VPC peering connection ID
}
