output "arn" {
  value = aws_sns_topic.event-bus.arn
}

output "name" {
  value = aws_sns_topic.event-bus.name
}
