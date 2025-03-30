resource "aws_cognito_user_pool" "user_pool" {
    name = "user_pool_from_terraform"
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
    name = "user_pool_client_from_terraform"
    user_pool_id = aws_cognito_user_pool.user_pool.id
    generate_secret = false
    explicit_auth_flows = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
}

resource "aws_cognito_user_pool_domain" "user_pool_domain" {
    domain = "cognito-auth"
    user_pool_id = aws_cognito_user_pool.user_pool.id
}
