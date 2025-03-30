resource "aws_lambda_function" "ReadFromDB" {
    function_name = "Read_From_DB"
    role = var.db_read_role_arn
    handler = "lambda_function.lambda_handler"
    runtime = "python3.8"
    # filename = "lambda_read_from_db.zip"

    environment {
        variables = {
            TABLE_NAME = var.dbname
        }
    }
}

resource "aws_lambda_function" "CastToLLM" {
    function_name = "Cast_To_LLM"
    role = var.db_write_role_arn
    handler = "lambda_function.lambda_handler"
    runtime = "python3.8"
    # filename = "lambda_cast_to_llm.zip"

    environment {
        variables = {
            TABLE_NAME = var.dbname
        }
    }
}

resource "aws_lambda_function" "CastToOCR" {
    function_name = "Cast_To_OCR"
    role = var.lambda_execution_role
    handler = "lambda_function.lambda_handler"
    runtime = "python3.8"
    # filename = "lambda_cast_to_ocr.zip"
}
