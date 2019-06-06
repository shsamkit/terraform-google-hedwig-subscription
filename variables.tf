variable "queue" {
  description = "Subscription queue (e.g. dev-myapp); unique across your infra"
}

variable "topic" {
  description = "Name of the Cloud Pub/Sub Topic"
}

variable "labels" {
  description = "Labels to attach to the subscription"
  type        = "map"
}
