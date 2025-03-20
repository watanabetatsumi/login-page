# EC2のみが扱えるロールを作成
resource "aws_iam_role" "ec2_role" {
    name = "EC2_Code_Deploy_Role"

    assume_role_policy = jsondecode({
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

resource "aws_iam_policy_attachment" "ec2_role_policy" {
    name = "EC2_Code_Deploy_Policy"
    roles = [aws_iam_role.ec2_role.name] 
    policy_arn = "arn:aws:iam::policy/AmazonEC2FullAccess"
}

# EC2にIAMロールを適用するためのプロファイルを作成
resource "aws_iam_instance_profile" "ec2_role_profile" {
  name = "EC2role-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role" "codedeploy_role" {
    name = "CodeDeploy_Role"

    assume_role_policy = jsondecode({
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

resource "aws_iam_policy_attachment" "codedeploy_role_policy" {
    name = "CodeDeploy_Policy"
    roles = [aws_iam_role.codedeploy_role.name] 
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}
