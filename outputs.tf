output "broker_id" {
  description = "The ID of the RabbitMQ broker"
  value       = aws_mq_broker.rabbitmq.id
}

output "broker_arn" {
  description = "The ARN of the RabbitMQ broker"
  value       = aws_mq_broker.rabbitmq.arn
}

output "broker_instances" {
  description = "The instances of the RabbitMQ broker"
  value       = aws_mq_broker.rabbitmq.instances
}


