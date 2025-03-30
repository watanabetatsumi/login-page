resource  "aws_vpc" "main" {
    cidr_block = var.cidr_block
    enable_dns_support = true
    # enable_dns_hostnames = true
    tags = {
        Name = "my-VPC-from-Terraform"
    }
}

resource  "aws_subnet" "public_a" {
    vpc_id = aws_vpc.main.id
    cidr_block = cidrsubnet(var.cidr_block, 8, 1)
    availability_zone = "ap-northeast-1a"
    map_public_ip_on_launch = true
    tags = {
        Name = "PublicSubnet_C-from-Terraform-${var.stage}"
    }
}

resource  "aws_subnet" "public_c" {
    vpc_id = aws_vpc.main.id
    cidr_block = cidrsubnet(var.cidr_block, 8, 2)
    availability_zone = "ap-northeast-1c"
    map_public_ip_on_launch = true
    tags = {
        Name = "PublicSubnet_A-from-Terraform-${var.stage}"
    }
}

resource  "aws_subnet" "private_a" {
    vpc_id = aws_vpc.main.id
    cidr_block = cidrsubnet(var.cidr_block, 8, 11)
    availability_zone = "ap-northeast-1a"
    tags = {
        Name = "PrivateSubnet_A-from-Terraform-${var.stage}"
    }
}
