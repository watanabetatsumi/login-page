# ASGで使用するEC2インスタンスのテンプレ設定
resource "aws_launch_template" "ec2_template"{
    name = "myEC2-template-from-Terraform"
    image_id = "ami-0a290015b99140cd1"
    instance_type = "t2.micro"
    key_name = var.key_name
    network_interfaces {
      associate_public_ip_address = true
      security_groups = [var.security_group_id]
    }
}

# スケールのさせ方
resource "aws_autoscaling_group" "ec2_asg" {
    name = "myASG-from-Terraform"
    max_size = 2
    min_size = 1
    desired_capacity = 1
    health_check_grace_period = 300
    health_check_type = "EC2"
    enabled_metrics = ["GroupInServiceInstances"]
    launch_template {
      id = aws_launch_template.ec2_template.id
      version = "$Latest"
    }
    vpc_zone_identifier = var.public_subnet_ids
    target_group_arns = [var.elb_target_group_arn]
}

# どんな時にスケールするの？
resource "aws_autoscaling_policy" "asg_policy" {
    name = "myASG-policy-from-Terraform"
    autoscaling_group_name = aws_autoscaling_group.ec2_asg.name
    policy_type = "TargetTrackingScaling"

    target_tracking_configuration {
        predefined_metric_specification {
            predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 50.0
    }
}
