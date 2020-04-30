variable "queue" {
  description = "Subscription queue (e.g. dev-myapp); unique across your infra"
}

variable "topic" {
  description = "Name of the Cloud Pub/Sub Topic"
}

variable "labels" {
  description = "Labels to attach to the subscription"
  type        = map(string)
}

variable "iam_service_account" {
  description = "The IAM service account to create exclusive IAM permissions for the subscription"
  default     = ""
}
