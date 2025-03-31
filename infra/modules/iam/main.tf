# EC2のみが扱えるロールを作成
resource "aws_iam_role" "ec2_role" {
    name = "EC2_Role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
            }
            Action = "sts:AssumeRole"
        }]
    })
}

resource "aws_iam_policy" "ec2_custom_policy" {
  name        = "EC2_Custom_Policy"
  description = "EC2 用のカスタムポリシー（EC2, SSM, CodeDeploy, S3 の権限を統合）"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:*",
          "ssm:*",
          "codedeploy:*",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      }
    ]
  })
}

# 1つのポリシーを IAM ロールにアタッチ
resource "aws_iam_policy_attachment" "ec2_custom_policy_attachment" {
  name       = "EC2_Custom_Policy_Attachment"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = aws_iam_policy.ec2_custom_policy.arn
}

# EC2にIAMロールを適用するためのプロファイルを作成
resource "aws_iam_instance_profile" "ec2_role_profile" {
  name = "EC2role-profile-v2"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role" "codedeploy_role" {
    name = "CodeDeploy_Service_Role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Principal = {
                Service = "codedeploy.amazonaws.com"
            }
            Action = "sts:AssumeRole"
        }]
    })
}

resource "aws_iam_policy_attachment" "codedeploy_policy" {
    name       = "CodeDeploy_Service_Policy"
    roles      = [aws_iam_role.codedeploy_role.name]
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}


resource "aws_iam_role" "dynamodb_role_r"{
    name = "DynamoDB_ReadOnly_Role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Principal = {
                Service = "lambda.amazonaws.com"
            }
            Action = "sts:AssumeRole"
        }]
    })
}

resource "aws_iam_role" "dynamodb_role_w"{
    name = "DynamoDB_Write_Role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Principal = {
                Service = "lambda.amazonaws.com"
            }
            Action = "sts:AssumeRole"
        }]
    })
}

resource "aws_iam_role" "lambda_execution_role" {
    name = "Lambda_Execution_Role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Principal = {
                Service = "lambda.amazonaws.com"
            }
            Action = "sts:AssumeRole"
        }]
    })
  
}

resource "aws_iam_policy" "dynamodb_role_r_policy" {
    name = "DynamoDB_ReadOnly_Policy"
    description = "Policy for DynamoDB ReadOnly Role"

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Action = [
                "dynamodb:GetItem",
                "dynamodb:Query",
                "dynamodb:Scan",
                "dynamodb:BatchGetItem",
                "dynamodb:DescribeTable",
                "dynamodb:ListTables",
                "cloudwatch:ListMetrics",
                "cloudwatch:GetMetricData",
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:GetRole",
                "iam:GetRolePolicy",
                "iam:ListAttachedRolePolicies",
                "iam:ListRolePolicies",
                "iam:ListRoles",
                "lambda:*",
                "logs:DescribeLogGroups",
                "states:DescribeStateMachine",
                "states:ListStateMachines",
                "tag:GetResources",
                "xray:GetTraceSummaries",
                "xray:BatchGetTraces"
            ]
            Resource = "*"
        }]
    })
}

resource "aws_iam_policy" "dynamodb_role_w_policy" {
    name = "DynamoDB_Write_Policy"
    description = "Policy for DynamoDB Write Role"

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Action = [
                "dynamodb:PutItem",
                "dynamodb:UpdateItem",
                "dynamodb:DeleteItem",
                "cloudwatch:ListMetrics",
                "cloudwatch:GetMetricData",
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:GetRole",
                "iam:GetRolePolicy",
                "iam:ListAttachedRolePolicies",
                "iam:ListRolePolicies",
                "iam:ListRoles",
                "lambda:*",
                "logs:DescribeLogGroups",
                "states:DescribeStateMachine",
                "states:ListStateMachines",
                "tag:GetResources",
                "xray:GetTraceSummaries",
                "xray:BatchGetTraces"
            ]
            Resource = "*"
        }]
    })
}

resource "aws_iam_policy" "lambda_execuion_role_policy" {
    name = "Lambda_Execution_Policy"
    description = "Policy for Lambda Execution Role"

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Action = [
                "cloudwatch:ListMetrics",
                "cloudwatch:GetMetricData",
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:GetRole",
                "iam:GetRolePolicy",
                "iam:ListAttachedRolePolicies",
                "iam:ListRolePolicies",
                "iam:ListRoles",
                "lambda:*",
                "logs:DescribeLogGroups",
                "states:DescribeStateMachine",
                "states:ListStateMachines",
                "tag:GetResources",
                "xray:GetTraceSummaries",
                "xray:BatchGetTraces"
            ]
            Resource = "*"
        }]
    })
}

resource "aws_iam_policy_attachment" "dynamodb_role_r_attachment" {
    name = "DynamoDB_ReadOnly_Attachment"
    roles = [aws_iam_role.dynamodb_role_r.name]
    policy_arn = aws_iam_policy.dynamodb_role_r_policy.arn
}

resource "aws_iam_policy_attachment" "dynamodb_role_w_attachment" {
    name = "DynamoDB_Write_Attachment"
    roles = [aws_iam_role.dynamodb_role_w.name]
    policy_arn = aws_iam_policy.dynamodb_role_w_policy.arn
}

resource "aws_iam_policy_attachment" "lambda_execution_role_attachment" {
    name = "Lambda_Execution_Attachment"
    roles = [aws_iam_role.lambda_execution_role.name]
    policy_arn = aws_iam_policy.lambda_execuion_role_policy.arn
}


resource "aws_iam_user" "github_actions_user" {
  name = "github-actions-user"
}


resource "aws_iam_policy" "github_actions_s3_codedeploy_policy" {
  name        = "GitHubActionsS3CodeDeployPolicy"
  description = "Policy for GitHub Actions to access S3 and CodeDeploy"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "codedeploy:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "github_actions_user_policy" {
  name       = "GitHubActionsUserPolicyAttachment"
  users      = [aws_iam_user.github_actions_user.name]  # 修正
  policy_arn = aws_iam_policy.github_actions_s3_codedeploy_policy.arn
}

