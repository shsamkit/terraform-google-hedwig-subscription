resource "google_pubsub_subscription" "subscription" {
  // topic name already has the `hedwig-` prefix which doesn't need to be duplicated.
  name  = "hedwig-${var.queue}-${substr(var.topic, length("hedwig-"), -1)}"
  topic = "${var.topic}"

  ack_deadline_seconds = 20

  labels = "${var.labels}"

  expiration_policy {}
}
