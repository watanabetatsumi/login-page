resource "aws_codedeploy_app" "cicd_app" {
    name = "App"
}


# 自動デプロイする対象を指定
resource "aws_codedeploy_deployment_group" "cicd_group" {
    app_name = aws_codedeploy_app.cicd_app.name
    deployment_group_name = "cicd_group_EC2s"
    service_role_arn = var.iam_code_deploy_arn

    autoscaling_groups = [var.ec2_auto_scaling_group_name]

    deployment_style {
        deployment_option = "WITH_TRAFFIC_CONTROL"
        deployment_type = "BLUE_GREEN"
    }

    blue_green_deployment_config {
        deployment_ready_option {
          action_on_timeout = "CONTINUE_DEPLOYMENT"
        }

        terminate_blue_instances_on_deployment_success {
            action = "TERMINATE"
        }
    }

    ec2_tag_set {
        ec2_tag_filter {
        key   = "CodeDeploy"
        type  = "KEY_AND_VALUE"
        value = "Target"
        }
    }

    load_balancer_info {
        target_group_info {
            name = var.elb_target_group_name
        }
    }
}
