# hls-streaming-gcp

An example on how to setup a HLS transcoding pipeline on Google Cloud and stream it through a CDN to your mobile app

![Architecture Diagram](./architecture_diagram.svg)

Instructions are on a tutorial which is going to be published soon.

# Deploying through Terraform

*WARNING - WIP, NOT FULLY WORKING YET*

Use the Terraform config yo automatically deploy all components in a new project of your choice.

First create a project and then, edit terraform variables in terraform.tfvars

After that, run:

`terraform plan`

`terrform apply`
