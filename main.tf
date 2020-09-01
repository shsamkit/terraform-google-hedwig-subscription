data "google_project" "current" {}

locals {
  regex_result  = regexall("projects/([^/]+)/topics/(.+)", var.topic)
  cross_project = length(local.regex_result) > 0
  topic_name    = local.cross_project ? local.regex_result[0][1] : var.topic
  // topic name already has the `hedwig-` prefix which doesn't need to be duplicated.
  truncated_topic_name = replace(local.topic_name, "hedwig-", "")
  project_id           = local.cross_project ? local.regex_result[0][0] : ""
  subscription_name    = local.cross_project ? "hedwig-${var.queue}-${local.project_id}-${local.truncated_topic_name}" : "hedwig-${var.queue}-${local.truncated_topic_name}"
}

resource "google_pubsub_subscription" "subscription" {
  name  = local.subscription_name
  topic = var.topic

  ack_deadline_seconds = 20

  enable_message_ordering = var.enable_message_ordering

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
