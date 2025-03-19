output "acm_certificate_arn" {
    value = aws_acm_certificate.certificate.arn
}

output "dns_zone_id" {
    value = aws_route53_zone.r53_zone.zone_id
}
