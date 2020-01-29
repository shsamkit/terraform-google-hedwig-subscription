resource "google_pubsub_subscription" "subscription" {
  // topic name already has the `hedwig-` prefix which doesn't need to be duplicated.
  name  = "hedwig-${var.queue}-${substr(var.topic, length("hedwig-"), -1)}"
  topic = "${var.topic}"

  ack_deadline_seconds = 20

  labels = "${var.labels}"

  expiration_policy {
    ttl = ""
  }
}

data "google_iam_policy" "subscription_policy" {
  binding {
    members = ["serviceAccount:${var.iam_service_account}"]
    role    = "roles/pubsub.subscriber"
  }

  binding {
    members = ["serviceAccount:${var.iam_service_account}"]
    role    = "roles/pubsub.viewer"
  }
}

resource "google_pubsub_subscription_iam_policy" "subscription_policy" {
  count = "${var.iam_service_account == "" ? 0 : 1}"

  policy_data  = "${data.google_iam_policy.subscription_policy.policy_data}"
  subscription = "${google_pubsub_subscription.subscription.name}"
}
