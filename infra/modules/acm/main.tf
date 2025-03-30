# route53にドメインを登録する。（ホストゾーンを作成する）
resource "aws_route53_zone" "r53_zone" {
  name = var.domain_name
}
# NS（ネームサーバ）レコード（AWSのどの権威DNSサーバーが知っているのか）が生成される

# 自身のドメイン名義で証明書を発行する
resource "aws_acm_certificate" "certificate" {
  domain_name = var.domain_name
  validation_method = "DNS"
}

# CNAMEレコードの登録
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  zone_id = aws_route53_zone.r53_zone.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
  allow_overwrite = true
}

# 証明書の検証
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = aws_acm_certificate.certificate.arn
  validation_record_fqdns = values(aws_route53_record.cert_validation)[*].fqdn
}
