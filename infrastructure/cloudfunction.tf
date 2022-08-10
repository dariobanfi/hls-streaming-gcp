provider "google-beta" {
    project = var.project_id
}


resource "google_storage_bucket" "cloudfunction_source" {
    name          = "cloudfunction-source-${var.project_id}"
    location      = var.region
    force_destroy = true  
    uniform_bucket_level_access = true
}

data "archive_file" "source" {
  type        = "zip"
  source_dir  = "../transcoding_function"
  output_path = "/tmp/function.zip"
}

resource "google_storage_bucket_object" "zip" {
  name   = "${data.archive_file.source.output_md5}.zip"
  bucket = google_storage_bucket.cloudfunction_source.name
  source = data.archive_file.source.output_path
}

resource "google_eventarc_trigger" "upload" {
  name     = "eventarc-upload-trigger"
  location = var.region
  matching_criteria {
    attribute = "type"
    value     = "google.cloud.storage.object.v1.finalized"
  }
  matching_criteria {
    attribute = "bucket"
    value     = google_storage_bucket.raw_files.name
  }
  destination {
    workflow = google_workflows_workflow.process_file.id
  }
  service_account = google_service_account.transcoder_service_account.email
}

resource "google_cloudfunctions2_function" "function" {

    provider = google-beta
    location = var.region


    name        = "transcoding-function"
    description = "Transcoding Function"

    build_config {
        runtime = "python310"
        entry_point = "handle_gcs_event"
        source {
            storage_source {
                bucket = google_storage_bucket.cloudfunction_source.name
            }
        }
    }

    service_config {
        max_instance_count  = 1
        available_memory    = "256M"
        timeout_seconds     = 60
        service_account_email = google_service_account.transcoder_service_account.email
    }
}