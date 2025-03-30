resource "aws_dynamodb_table" "LLM_results" {
    name = "LLM_results"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "user_id"
    range_key = "created_at"

    attribute {
        name = "user_id"
        type = "S"
    }
    attribute {
        name = "created_at"
        type = "S"
    }
    point_in_time_recovery {
    enabled = true
    }

    server_side_encryption {
        enabled = true
    }
}
