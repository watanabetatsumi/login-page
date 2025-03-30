resource "aws_s3_bucket" "OCR_output_bucket" {
    bucket = "ocr-output-bucket-terraform"
}

# # 外部からデータにアクセスできないようにする
# resource "aws_s3_bucket_acl" "OCR_output_bucket_acl" {
#     bucket = aws_s3_bucket.OCR_output_bucket.id
#     acl = "private"
# }

resource "aws_s3_bucket" "codedeploy_bucket"{
    bucket = "codedeploy-bucket-terraform"
}


# # 外部からデータにアクセスできないようにする
# resource "aws_s3_bucket_acl" "codedeploy_bucket_acl" {
#     bucket = aws_s3_bucket.codedeploy_bucket.id
#     acl = "private"
# } 

# # 古いバージョンのも復元できるようにバージョニングを有効化
# resource "aws_s3_bucket_versioning" "codedeploy_bucket_versioning" {
#     bucket = aws_s3_bucket.codedeploy_bucket.id
#     versioning_configuration {
#       status = "Enabled"
#     }
# }

resource "aws_s3_bucket_policy" "codedeploy_bucket_policy" {
    bucket = aws_s3_bucket.codedeploy_bucket.id
    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect = "Allow",
                "Principal": {
                    "Service": "codedeploy.amazonaws.com"
                    }
                Action = "s3:GetObject",
                Resource = "${aws_s3_bucket.codedeploy_bucket.arn}/*"
            }
        ]
    })
}
