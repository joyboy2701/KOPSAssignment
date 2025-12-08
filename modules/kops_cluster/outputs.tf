output "state_store_bucket_name" {
  value = replace(var.state_store, "s3://", "")
}