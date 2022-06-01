resource "aws_cloudfront_origin_access_identity" "oad_s3resume" {
}

resource "aws_cloudfront_distribution" "resume_distribution" {
  depends_on = [
    aws_lambda_function.lambda_visit_counter
  ]
  origin {
    domain_name = aws_s3_bucket.cv_bucket.bucket_regional_domain_name
    origin_id   = "s3ResumeOrigin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oad_s3resume.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = ["cv.ad3f.me", "resume.ad3f.me"]

  default_cache_behavior {
    allowed_methods  = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
    cached_methods   = ["HEAD", "GET"]
    target_origin_id = "s3ResumeOrigin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate_validation.cv_cert_valid.certificate_arn
    ssl_support_method  = "sni-only"
  }
}