resource "random_uuid" "uuid" {
}

resource "aws_s3_bucket" "cv_bucket" {
  bucket = "${random_uuid.uuid.result}-ad3f"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket" "tf_store" {
  bucket = "${random_uuid.uuid.result}-ad3f-tf-config"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_acl" "cv_bucket_acl" {
  bucket = aws_s3_bucket.cv_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "cv_public_block" {
  bucket              = aws_s3_bucket.cv_bucket.id
  block_public_policy = false
}

resource "aws_s3_bucket_cors_configuration" "cv_cors" {
  bucket = aws_s3_bucket.cv_bucket.bucket
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "GET"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_website_configuration" "cv_bucket_site" {
  bucket = aws_s3_bucket.cv_bucket.id
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "allow_access_cf" {
  bucket = aws_s3_bucket.cv_bucket.id
  policy = data.aws_iam_policy_document.allow_access_cf.json
}

data "aws_iam_policy_document" "allow_access_cf" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oad_s3resume.iam_arn]
    }
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      "${aws_s3_bucket.cv_bucket.arn}/*",
      "${aws_s3_bucket.cv_bucket.arn}"
    ]
  }
}