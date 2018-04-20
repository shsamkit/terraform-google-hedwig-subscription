resource "aws_sns_topic_subscription" "subscription" {
  topic_arn            = "${var.topic}"
  protocol             = "sqs"
  endpoint             = "${var.queue}"
  raw_message_delivery = true
}
