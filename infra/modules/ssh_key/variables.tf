# ローカル変数の定義
locals {
    ssh_dir = "${path.module}/.ssh"
    public_key = "${local.ssh_dir}/myproject.id_rsa.pub"
    secret_key = "${local.ssh_dir}/myproject.id_rsa"
}

