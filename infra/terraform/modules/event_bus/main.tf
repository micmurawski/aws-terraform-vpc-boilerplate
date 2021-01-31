resource "aws_sns_topic" "dataops-fm-event-bus" {
  name = "dataops-fm-event-bus-1"
  tags = var.tags
}
