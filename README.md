# hls-streaming-gcp

An example on how to setup a HLS transcoding pipeline on Google Cloud and stream it through a CDN to your mobile app

![Architecture Diagram](./architecture_diagram.svg)

Instructions are on a tutorial which is going to be published soon.

# Deploying through Terraform

Use the Terraform config yo automatically deploy all components in a new project of your choice.

First create a new Google Cloud project and then, edit terraform variables in `terraform.tfvars`

After that, run:

`terraform plan`

`terrform apply`

Terraform will take care about enabling all APIs and deploying the automation.

After that, you can test it by uploading a file in the newly created raw-files bucket:

`gsutil cp sample.mov gs://hls-streaming-gcp-raw-files-${PROJECT_ID}`


# Troubleshooting

There is a chance that running Terraform script on a new project fails with: `Error 400: Cannot create trigger ... Permission denied while using the Eventarc Service Agent.`
This is because of a propagation issue with EventArc when creating the first triggers. In that case, just wait a couple of minutes and run it again.


