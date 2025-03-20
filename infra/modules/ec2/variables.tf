variable key_name {
    type = string
}
variable public_subnet_ids {
    type = list(string)
} 
variable security_group_id {
    type = string
}

variable elb_target_group_arn {
    type = string
}

variable ec2_role_profile {
    type = string
}
