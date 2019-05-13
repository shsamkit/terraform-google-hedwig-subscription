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

variable "dataflow_tmp_gcs_location" {
  description = "A gs bucket location for storing temporary files by Google Dataflow, e.g. gs://myBucket/tmp"
}

variable "dataflow_template_gcs_path" {
  description = "The template path for Google Dataflow, e.g. gs://dataflow-templates/2019-04-03-00/Cloud_PubSub_to_Cloud_PubSub"
}

variable "dataflow_zone" {
  description = "The zone to use for Dataflow. This may be required if it's not set at the provider level, or that zone doesn't support Dataflow"
}
