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


resource "aws_subnet" "database" {
    count = length(var.public_sub_cidr)
    vpc_id     = aws_vpc.main.id
    cidr_block = var.database_sub_cidr
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