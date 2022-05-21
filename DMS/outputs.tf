output "primary-rds-endpoint" {
  value = aws_dms_endpoint.primary_endpoint.endpoint_arn
}

output "secondary-rds-endpoint" {
  value = aws_dms_endpoint.secondary_endpoint.endpoint_arn
}

output "dms-task-arn" {
  value = aws_dms_replication_task.dms-task.replication_task_arn
}
