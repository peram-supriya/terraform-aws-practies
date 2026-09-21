resource "aws_vpc" "main" {
    cidr_block       = var.cidr_block
    instance_tenancy = "default"
    enable_dns_hostnames = true

    tags = local.vpc_final_tags
}


resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id  #association

  tags = local.gt_final_tags
}

#public subnet

resource "aws_subnet" "public" {
    count = length(var.public_sub_cidr)
    vpc_id     = aws_vpc.main.id
    cidr_block = var.public_sub_cidr[count.index]
    availability_zone = local.az_info[count.index]
    map_public_ip_on_launch = true

    tags = merge(
        local.comman_tags,
        {
            Name = "${var.project}-${var.environment}-public-${local.az_info[count.index]}"
        },
        var.public_sub_tags

    )
}

#private subnet

resource "aws_subnet" "private" {
    count = length(var.public_sub_cidr)
    vpc_id     = aws_vpc.main.id
    cidr_block = var.private_sub_cidr[count.index]
    availability_zone = local.az_info[count.index]
    map_public_ip_on_launch = false

    tags = merge(
        local.comman_tags,
        {
            Name = "${var.project}-${var.environment}-private-${local.az_info[count.index]}"
        },
        var.public_sub_tags

    )
}

#database subnet

resource "aws_subnet" "database" {
    count = length(var.public_sub_cidr)
    vpc_id     = aws_vpc.main.id
    cidr_block = var.database_sub_cidr[count.index]
    availability_zone = local.az_info[count.index]
    map_public_ip_on_launch = false

    tags = merge(
        local.comman_tags,
        {
            Name = "${var.project}-${var.environment}-database-${local.az_info[count.index]}"
        },
        var.public_sub_tags

    )
}

#public route table

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
        local.comman_tags,
        {
            Name = "${var.project}-${var.environment}-public"
        },
        var.public_route_table_tags

    )
}

#private route table

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
        local.comman_tags,
        {
            Name = "${var.project}-${var.environment}-private"
        },
        var.public_route_table_tags

    )
}

#database route table

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
        local.comman_tags,
        {
            Name = "${var.project}-${var.environment}-database"
        },
        var.public_route_table_tags

    )
}

#route 

resource "aws_route" "public" {
  route_table_id            = aws_route_table.public
  destination_cidr_block    = "0.0.0.0/0"
 gateway_id                 = aws_internet_gateway.main.id
}

#elastic ip

resource "aws_eip" "nat" {
  domain                    = "vpc"
  tags = merge(
        local.comman_tags,
        {
            Name = "${var.project}-${var.environment}-nat"
        },
        var.eip_tags
  )
}

#natgate way

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id  # we creating us-east-1a

  tags = merge(
        local.comman_tags,
        {
            Name = "${var.project}-${var.environment}"
        },
        var.nat_tags
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}

resource "aws_route" "private" {
    route_table_id            = aws_route_table.private
    destination_cidr_block    = "0.0.0.0/0"
    nat_gateway_id            = aws_nat_gateway.main.id
}

resource "aws_route" "private" {
    route_table_id            = aws_route_table.private
    destination_cidr_block    = "0.0.0.0/0"
    nat_gateway_id             = aws_nat_gateway.main.id
}



