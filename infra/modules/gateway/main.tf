resource  "aws_internet_gateway" "igw" {
    vpc_id = var.vpc_id

    tags = {
        Name = "myIGW-from-Terraform"
    }
}

resource "aws_route_table" "router0" {
    vpc_id = var.vpc_id

    tags = {
        Name = "my-IGW-RouteTable-from-Terraform"
    }
}

resource "aws_route" "route_info0" {
    route_table_id = aws_route_table.router0.id
    # デフォルトルートの設定
    destination_cidr_block = "0.0.0.0/0"
    # igw(インターフェース)へのルーティング
    gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "association_public"{
    # リストの要素を取り出して、ループ
    count = length(var.public_subnet_ids)
    route_table_id = aws_route_table.router0.id
    subnet_id = var.public_subnet_ids[count.index]
}
