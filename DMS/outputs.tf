output "primary-rds-endpoing" {
  value = aws_dms_endpoint.primary_endpoint.endpoint_arn
}

output "secondary-rds-endpoing" {
  value = aws_dms_endpoint.secondary_endpoint.endpoint_arn
}

output "secondary-rds-endpoing" {
  value = aws_dms_replication_task.dms-task.replication_task_arn
}