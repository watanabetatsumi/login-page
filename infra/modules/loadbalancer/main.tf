resource "aws_lb" "elb" {
    name = "myELB-terraform"
    internal = false
    load_balancer_type = "application"
    security_groups = [var.security_group_id]
    subnets = var.public_subnet_ids
    enable_deletion_protection = false
    tags = {
        Name = "myELB-terraform"
    }
}

# ターゲットグループの作成
resource "aws_lb_target_group" "elb_target_group" {
  name = "myELB-target-group-terraform"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 20
    matcher             = "200"
  }
}

# httpはhttpsへリダイレクト
resource "aws_lb_listener" "elb_listener_http" {
  load_balancer_arn = aws_lb.elb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "redirect"
    redirect {
        protocol = "HTTPS"
        port = "443"
        status_code = "HTTP_301"
    }
  }
}

# httpsの場合のLister Rule
resource "aws_lb_listener" "elb_listener_https"{
    load_balancer_arn = aws_lb.elb.arn
    port = 443
    protocol = "HTTPS"
    ssl_policy = "ELBSecurityPolicy-2016-08"
    certificate_arn = var.acm_certificate_arn

    default_action {
        type = "fixed-response"
        fixed_response {
          content_type = "text/plain"
          message_body = "Not Found"
          status_code =  "404"
        }
    }
}

# 追加のListen Rule
resource "aws_lb_listener_rule" "elb_listener_rule" {
  listener_arn = aws_lb_listener.elb_listener_https.arn
  priority = 10

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.elb_target_group.arn
  }

  condition {
    path_pattern {
        values = ["/"]
    }
  }
}

# A(エイリアス)レコードの登録
resource "aws_route53_record" "elb_record" {
  zone_id = var.dns_zone_id
  name = var.domain_name
  type = "A"

  # ドメインをelbにマッピング
  alias {
    name = aws_lb.elb.dns_name
    zone_id = aws_lb.elb.zone_id
    evaluate_target_health = true
  }
}
