resource "google_pubsub_subscription" "subscription" {
  // topic name already has the `hedwig-` prefix which doesn't need to be duplicated.
  name  = "hedwig-${var.queue}-${substr(var.topic, length("hedwig-"), -1)}"
  topic = "${var.topic}"

  ack_deadline_seconds = 20

  labels = "${var.labels}"
}

data "google_client_config" "current" {}

resource "google_dataflow_job" "dataflow" {
  name = "${google_pubsub_subscription.subscription.name}"
  temp_gcs_location = "${var.dataflow_tmp_gcs_location}"
  template_gcs_path = "${var.dataflow_template_gcs_path}"

  parameters = {
    inputSubscription = "projects/${data.google_client_config.current.project}/subscriptions/${google_pubsub_subscription.subscription.name}"
    outputTopic = "projects/${data.google_client_config.current.project}/topics/hedwig-${var.queue}"
  }
}
