resource "google_project_service" "cloudfunctions_service" {
    project = var.project_id
    service = "cloudfunctions.googleapis.com"
}

resource "google_project_service" "cloudbuild_service" {
    project = var.project_id
    service = "cloudbuild.googleapis.com"
}

resource "google_project_service" "pubsub_service" {
    project = var.project_id
    service = "pubsub.googleapis.com"
}

resource "google_project_service" "artifactregistry_service" {
    project = var.project_id
    service = "artifactregistry.googleapis.com"
}

resource "google_project_service" "run_service" {
    project = var.project_id
    service = "run.googleapis.com"
}

resource "google_project_service" "eventarc_service" {
    project = var.project_id
    service = "eventarc.googleapis.com"
}

resource "google_project_service" "logging_service" {
    project = var.project_id
    service = "logging.googleapis.com"
}

resource "google_project_service" "transcoder_service" {
    project = var.project_id
    service = "transcoder.googleapis.com"
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

resource "google_cloudfunctions2_function" "function" {
    location = var.region

    name        = "transcoding-function"
    description = "Transcoding Function"

    build_config {
        runtime = "python310"
        entry_point = "handle_gcs_event"
        source {
            storage_source {
                bucket = google_storage_bucket.cloudfunction_source.name
                object = "${data.archive_file.source.output_md5}.zip"
            }
        }
    }

    service_config {
        max_instance_count  = 1
        available_memory    = "256M"
        timeout_seconds     = 60
        service_account_email = google_service_account.transcoder_service_account.email
        environment_variables = {
            PROJECT_ID = var.project_id
            REGION = var.region
        }

    }

    event_trigger {
        trigger_region = var.region
        event_type = "google.cloud.storage.object.v1.finalized"
        retry_policy = "RETRY_POLICY_RETRY"
        service_account_email = google_service_account.transcoder_service_account.email
        event_filters {
            attribute = "bucket"
            value = google_storage_bucket.raw_files.name
        }
    }

    depends_on = [
        google_project_service.cloudfunctions_service,
        google_project_service.pubsub_service,
        google_project_service.cloudbuild_service,
        google_project_service.artifactregistry_service,
        google_project_service.run_service,
        google_project_service.eventarc_service,
        google_project_service.logging_service,
        google_project_service.transcoder_service,
        google_service_account.transcoder_service_account,
    ]
}