output "subscription_path" {
  value       = "${google_pubsub_subscription.subscription.path}"
  description = "Path of the Subscription"
}

output "subscription_name" {
  value       = "${google_pubsub_subscription.subscription.name}"
  description = "Name of the Subscription"
}

output "dataflow_job_name" {
  value       = "${google_dataflow_job.dataflow.name}"
  description = "Dataflow job name"
}
