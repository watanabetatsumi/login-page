# key_pairを生成
resource "tls_private_key" "keygen" {
  algorithm = "RSA"
  rsa_bits = 2048
}

# 秘密鍵を保存
resource "local_file" "private_key_pem" {
    filename = local.secret_key
    content = tls_private_key.keygen.private_key_pem
    provisioner "local-exec" {
        command = "chmod 600 ${local.secret_key}"
    }
}

# 公開鍵を保存
resource "local_file" "public_key_openssh" {
    filename = local.public_key
    content = tls_private_key.keygen.public_key_openssh
    provisioner "local-exec" {
        command = "chmod 600 ${local.public_key}"
    }
}

# AWSに公開鍵を登録
resource "aws_key_pair" "key_pair" {
    key_name =  "myproject-key"
    public_key = tls_private_key.keygen.public_key_openssh
}
