output "security_group_id_ec2" {
    value = aws_security_group.allow_ssh_http.id
}

output "security_group_id_elb" {
    value = aws_security_group.allow_http_only.id
}
