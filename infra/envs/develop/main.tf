# モジュールをimport -> sourceでパスを指定
# module "~~" で名前を付ける 

module "provider" {
    source = "../../modules/provider"

    region = var.region
}

module "vpc" {
    source = "../../modules/vpc"

    stage = var.stage
    cidr_block = var.cidr_block
}

module "igw" {
    source = "../../modules/gateway"

    vpc_id = module.vpc.vpc_id
    public_subnet_ids = [
        module.vpc.public_subnet_id_A,
        module.vpc.public_subnet_id_C
        ]
}

module "keypair" {
    source = "../../modules/ssh_key"
}

module "iam_roles" {
    source = "../../modules/iam"
}

module "security_group" {
    source = "../../modules/security_group"

    vpc_id = module.vpc.vpc_id
}

module "s3" {
    source = "../../modules/s3_bucket"
}

module "db" {
    source = "../../modules/dynamoDB"
}

# module "apigateway" {
#     source = "../../modules/apigateway"

#     readDBfunc = module.lambda.readDBfunc
# }

# module "lambda" {
#     source = "../../modules/lambda"

#     dbname = module.db.dbname
#     db_write_role_arn = module.iam_roles.dynamoDB_write_role
#     db_read_role_arn = module.iam_roles.dynamoDB_read_role
#     lambda_execution_role = module.iam_roles.lambda_execution_role
# }

module "ACM" {
    source = "../../modules/acm"

    domain_name = var.domain_name
}

module "elb" {
    source = "../../modules/loadbalancer"

    security_group_id =  module.security_group.security_group_id_elb
    public_subnet_ids = [
        module.vpc.public_subnet_id_A,
        module.vpc.public_subnet_id_C
    ]

    acm_certificate_arn = module.ACM.acm_certificate_arn
    dns_zone_id = module.ACM.dns_zone_id
    domain_name = var.domain_name
    vpc_id = module.vpc.vpc_id
}

module "ec2" {
    source = "../../modules/ec2"

    # ssh用の公開鍵
    key_name = module.keypair.public_key
    public_subnet_ids = [
        module.vpc.public_subnet_id_A,
        module.vpc.public_subnet_id_C
        ]
    security_group_id = module.security_group.security_group_id_ec2
    elb_target_group_arn = module.elb.elb_target_group_arn
    ec2_role_profile = module.iam_roles.ec2_role_profile
}

module "codeDeploy"{
    source = "../../modules/cicd"

    iam_code_deploy_arn = module.iam_roles.codedeploy_role
    ec2_auto_scaling_group_name = module.ec2.autoscaling_group_name
    elb_name = module.elb.elb_name
    elb_target_group_name = module.elb.elb_target_gruop_name
}
