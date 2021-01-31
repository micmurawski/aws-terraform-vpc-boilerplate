resource "aws_sns_topic" "event-bus" {
  name = format("%s-%s", var.name, var.resource_prefix)
  tags = var.tags
}
