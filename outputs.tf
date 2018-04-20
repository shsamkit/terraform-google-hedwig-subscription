output "subscription_arn" {
  value       = "${aws_sns_topic_subscription.subscription.arn}"
  description = "ARN of the SNS subscription"
}
