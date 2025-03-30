resource "aws_apigatewayv2_api" "api_gateway" {
    name = "APIGateway"
    protocol_type = "HTTP"
}

resource "aws_apigatewayv2_route" "get_output" {
    api_id = aws_apigatewayv2_api.api_gateway.id
    route_key = "GET /output"
    target = "integrations/${aws_apigatewayv2_integration.ReadFromDB.id}"
}

resource "aws_apigatewayv2_integration" "ReadFromDB" {
    api_id = aws_apigatewayv2_api.api_gateway.id
    connection_type =  "INTERNET"
    integration_method = "GET"
    integration_type = "AWS_PROXY"
    integration_uri = var.readDBfunc
}
