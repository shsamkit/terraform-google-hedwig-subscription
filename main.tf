data "google_project" "current" {}

locals {
  cross_project = length(regexall("/", var.topic)) > 0
  topic_name    = local.cross_project ? split("/", var.topic)[3] : var.topic
  // topic name already has the `hedwig-` prefix which doesn't need to be duplicated.
  truncated_topic_name = replace(local.topic_name, "hedwig-", "")
  subscription_name    = "hedwig-${var.queue}-${local.truncated_topic_name}"
}

resource "google_pubsub_subscription" "subscription" {
  name  = local.subscription_name
  topic = var.topic

  ack_deadline_seconds = 21

  labels = var.labels

  expiration_policy {
    ttl = ""
  }

  dead_letter_policy {
    dead_letter_topic     = "projects/${data.google_project.current.project_id}/topics/hedwig-${var.queue}-dlq"
    max_delivery_attempts = 5
  }
}

data "google_iam_policy" "subscription_policy" {
  binding {
    members = [
      "serviceAccount:${var.iam_service_account}",
      "serviceAccount:service-${data.google_project.current.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
    ]
    role = "roles/pubsub.subscriber"
  }

  binding {
    members = [
      "serviceAccount:${var.iam_service_account}",
      "serviceAccount:service-${data.google_project.current.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
    ]
    role = "roles/pubsub.viewer"
  }
}

resource "google_pubsub_subscription_iam_policy" "subscription_policy" {
  count = var.iam_service_account == "" ? 0 : 1

  policy_data  = data.google_iam_policy.subscription_policy.policy_data
  subscription = google_pubsub_subscription.subscription.name
}
