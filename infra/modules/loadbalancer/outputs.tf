output "elb_target_group_arn" {
    value = aws_lb_target_group.elb_target_group.arn
}

output "elb_target_gruop_name" {
    value = aws_lb_target_group.elb_target_group.name
}

output "elb_name" {
    value = aws_lb.elb.name
}
