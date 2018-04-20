Hedwig Queue App Subscription Terraform module
==============================================

[Hedwig](https://github.com/Automatic/hedwig) is a inter-service communication bus that works on AWS SQS/SNS, while keeping things pretty simple and
straight forward. It uses [json schema](http://json-schema.org/) draft v4 for schema validation so all incoming
and outgoing messages are validated against pre-defined schema.

This module provides a custom [Terraform](https://www.terraform.io/) modules for deploying Hedwig infrastructure that
creates Hedwig subscriptions for Hedwig consumer apps.

## Usage

```hcl
module "topic-dev-user-updated-v1" {
  source = "Automatic/hedwig-topic/aws"
  topic  = "dev-user-updated-v1"
}

module "consumer-dev-app" {
  source = "Automatic/hedwig-queue/aws"
  topic  = "dev-myapp"
}

module "sub-dev-myapp-dev-user-updated" {
  source = "Automatic/hedwig-queue-subscription/aws"
  queue  = "${module.consumer-dev-app.queue_arn}"

  topic = "${module.topic-dev-user-updated-v1.arn}"
}
```

## Release Notes

[Github Releases](https://github.com/Automatic/terraform-aws-hedwig-queue-subscription/releases)

## How to publish

Go to [Terraform Registry](https://registry.terraform.io/modules/Automatic/hedwig-queue-subscription/aws), and 
Resync module.
