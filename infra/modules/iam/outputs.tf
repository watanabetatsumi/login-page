output "ec2_role_profile" {
    value = aws_iam_instance_profile.ec2_role_profile.name
}

output "dynamoDB_read_role" {
  value = aws_iam_role.dynamodb_role_r.arn
}

output "dynamoDB_write_role" {
  value = aws_iam_role.dynamodb_role_w.arn
}

output "lambda_execution_role" {
  value = aws_iam_role.lambda_execution_role.arn
}

output "codedeploy_role" {
  value = aws_iam_role.codedeploy_role.arn
}
