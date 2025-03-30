output "readDBfunc" {
    value = aws_lambda_function.ReadFromDB.invoke_arn
}
