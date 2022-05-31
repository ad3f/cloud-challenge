data "aws_route53_zone" "domain_zone" {
  name         = "ad3f.me"
  private_zone = false
}

resource "aws_route53_record" "resume_record" {
  depends_on = [
    aws_cloudfront_distribution.resume_distribution
  ]
  zone_id = data.aws_route53_zone.domain_zone.zone_id
  name    = "cv.ad3f.me"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.resume_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.resume_distribution.hosted_zone_id
    evaluate_target_health = false
  }

  allow_overwrite = true

}

resource "aws_acm_certificate" "cv_cert" {
  provider          = aws.aws_us1
  domain_name       = "*.ad3f.me"
  validation_method = "EMAIL"
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    "use" = "cloud_resume_challenge"
  }
}

resource "aws_acm_certificate_validation" "cv_cert_valid" {
provider = aws.aws_us1
  certificate_arn = aws_acm_certificate.cv_cert.arn
}

# --------------------------------------------------------------
