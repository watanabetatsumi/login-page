output "autoscaling_group_id" {
    value = aws_autoscaling_group.ec2_asg.id
}

output "autoscaling_group_name" {
    value = aws_autoscaling_group.ec2_asg.name
}
