resource "google_service_account" "transcoder_service_account" {
    account_id   = "transcoder-service-account"
    display_name = "Transcoder Service Account"
}

resource "google_project_iam_member" "run_invoker" {
    project = var.project_id
    role               = "roles/run.invoker"
    member             = "serviceAccount:${google_service_account.transcoder_service_account.account_id}@${var.project_id}.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "transcoder_admin" {
    project = var.project_id
    role               = "roles/transcoder.admin"
    member             = "serviceAccount:${google_service_account.transcoder_service_account.account_id}@${var.project_id}.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "storage_admin" {
    project = var.project_id
    role               = "roles/storage.admin"
    member             = "serviceAccount:${google_service_account.transcoder_service_account.account_id}@${var.project_id}.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "event_receiver" {
    project = var.project_id
    role               = "roles/eventarc.eventReceiver"
    member             = "serviceAccount:${google_service_account.transcoder_service_account.account_id}@${var.project_id}.iam.gserviceaccount.com"
}

// policy binding for compute 

data "google_storage_project_service_account" "gcs_account" {
}

resource "google_project_iam_member" "binding" {
    project = var.project_id
    role  = "roles/pubsub.publisher"
    member = "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"
}