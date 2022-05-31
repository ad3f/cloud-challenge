output "s3_bucket_name" {
  description = "Created S3 Bucket used to store function code"
  value       = aws_s3_bucket.cv_bucket.id
}

output "s3_bucket_uri" {
  description = "URI to s3 bucket"
  value       = aws_s3_bucket.cv_bucket.bucket_domain_name
}

output "s3_tf_config_bucket_name" {
  description = "Created S3 Bucket used to store tf configuration files"
  value       = aws_s3_bucket.tf_store.id
}

output "s3__tf_config_bucket_uri" {
  description = "URI to s3 bucket conftaining terraform configuration files"
  value       = aws_s3_bucket.tf_store.bucket_domain_name
}

output "function_name" {
  description = "Name of function run to retrieve and increment visitor number"
  value       = aws_lambda_function.lambda_visit_counter.function_name
}

output "invokation_url" {
  description = "URL for API Gateway Stage"
  value       = aws_apigatewayv2_stage.lambda.invoke_url
}