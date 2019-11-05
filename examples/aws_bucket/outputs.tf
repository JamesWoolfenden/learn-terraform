output "id" {
  value       = aws_s3_bucket.statebucket.id
  description = "The name of the bucket"
}

output "arn" {
  value       = aws_s3_bucket.statebucket.arn
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
}

output "bucket_domain_name" {
  value       = aws_s3_bucket.statebucket.bucket_domain_name
  description = "The bucket domain name. Will be of format bucketname.s3.amazonaws.com."
}

output "bucket_regional_domain_name" {
  value       = aws_s3_bucket.statebucket.bucket_regional_domain_name
  description = "The bucket region-specific domain name. The bucket domain name including the region name, please refer here for format. Note: The AWS CloudFront allows specifying S3 region-specific endpoint when creating S3 origin, it will prevent redirect issues from CloudFront to S3 Origin URL."
}

output "hosted_zone_id" {
  value       = aws_s3_bucket.statebucket.hosted_zone_id
  description = "The Route 53 Hosted Zone ID for this bucket's region."
}

output "region" {
  value       = aws_s3_bucket.statebucket.region
  description = "The AWS region this bucket resides in."
}
