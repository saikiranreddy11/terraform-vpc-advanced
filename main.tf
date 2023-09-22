resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support = var.enable_dns_support
  
  tags = merge(var.common_tags,
                var.vpc_tags,
                 {
                    "Name"= var.projectname
                })
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags,
                var.gw_tags,
                {
                    "Name"= var.projectname
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
                    "Name"= "${var.projectname}-public-${var.az[count.index]}"
                })
}

resource "aws_subnet" "private" {
    count = length(var.private_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_cidr_block[count.index]
  availability_zone = var.az[count.index]

  tags = merge(var.common_tags,
                {
                    "Name"= "${var.projectname}-private-${var.az[count.index]}"
                })
}

resource "aws_subnet" "database" {
    count = length(var.database_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_cidr_block[count.index]
  availability_zone = var.az[count.index]

  tags = merge(var.common_tags,
                 {
                    "Name"= "${var.projectname}-database-${var.az[count.index]}"
                })
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = var.public_route
    gateway_id = aws_internet_gateway.gw.id
  }

   tags = merge(var.common_tags,
                 {
                    "Name"= "${var.projectname}-public"
                },var.public_routetable_tags)
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.roboshop.id
  }
   tags = merge(var.common_tags,
                 {
                    "Name"= "${var.projectname}-private"
                },var.private_routetable_tags)
}
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id
  route {
     cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.roboshop.id
  }
   tags = merge(var.common_tags,
                 {
                    "Name"= "${var.projectname}-database"
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
      "Name"= "${var.projectname}"
  }
}

resource "aws_nat_gateway" "roboshop" {
  allocation_id = aws_eip.roboshop_eip.id
  subnet_id     = aws_subnet.public[0].id
  tags = merge(var.common_tags,
                 {
                    "Name"= "${var.projectname}-NAT"
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
        Name = var.projectname
    },
    var.db_subnet_group_tags
  )
}